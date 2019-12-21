function y = castFiToInt(u) %#codegen
    %castFiToInt if fi input has a MATLAB integer equivalent, then cast to it
    %
    %   y = castFiToInt(u)
    %   If input u is a fi object that is equivalent to one of base MATLAB's
    %   eight integer types int8, uint8, int16, uint16, int32, uint32, int64,
    %   uint64, then the input will be losslessly cast to the MATLAB
    %   equivalent type, otherwise the input will be passed through unchanged.
    %
    %   See also castIntToFi, cast64BitFiToInt, cast64BitIntToFi
    
    %   Copyright 2019 The MathWorks, Inc.
    
    %coder.inline('always');
    
    assertNeedOlderThanR2020a();
    
    if isFiInteger(u,[8,16,32,64])
        s = issigned(u);
        switch u.WordLength
            case 64
                if s
                    y = int64(u);
                else
                    y = uint64(u);
                end
            case 32
                if s
                    y = int32(u);
                else
                    y = uint32(u);
                end
            case 16
                if s
                    y = int16(u);
                else
                    y = uint16(u);
                end
            otherwise
                assert( 8 == u.WordLength );
                if s
                    y = int8(u);
                else
                    y = uint8(u);
                end
        end
    else
        y = u;
    end
end
