function y = castIntToFi(u) %#codegen
    %castIntToFi if MATLAB integer, then cast to fi equivalent
    %
    %   y = castIntToFi(u)
    %   If the input u is one of base MATLAB's eight integer types
    %   int8, uint8, int16, uint16, int32, uint32, int64, uint64,
    %   then the input will be losslessly cast to the fixed-point
    %   fi object equivalent type, otherwise
    %   the input will be passed through unchanged.
    %
    %   See also castFiToInt, cast64BitFiToInt, cast64BitIntToFi
    
    %   Copyright 2019 The MathWorks, Inc.
    
    %coder.inline('always');

    assertNeedOlderThanR2020a();
    
    if isinteger(u)
        y = fi(u);
    else
        y = u;
    end
end
