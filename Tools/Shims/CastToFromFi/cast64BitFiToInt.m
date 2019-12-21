function y = cast64BitFiToInt(u) %#codegen
    %cast64BitFiToInt if fi input is equivalent to u/int64, cast to that type
    %
    %   y = cast64BitFiToInt(u)
    %   If input u is a fi object that is equivalent to one of base MATLAB's
    %   64 bit integer types, int64 and uint64, then the input will be
    %   losslessly cast to the MATLAB equivalent type, otherwise the input
    %   will be passed through unchanged.
    %
    %   See also castIntToFi, castFiToInt, cast64BitIntToFi
    
    %   Copyright 2019 The MathWorks, Inc.
    
    %coder.inline('always');

    assertNeedOlderThanR2020a();
    
    if isFiInteger(u,64)
        s = issigned(u);
        if s
            y = int64(u);
        else
            y = uint64(u);
        end
    else
        y = u;
    end
end
