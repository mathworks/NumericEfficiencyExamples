function y = cast64BitIntToFi(u) %#codegen
    %cast64BitIntToFi if MATLAB 64 bit integer, then cast to fi equivalent
    %
    %   y = cast64BitIntToFi(u)
    %   If the input u is either of base MATLAB's two 64 bit integer types,
    %   int64 and uint64, then the input will be losslessly cast to the
    %   fixed-point fi object equivalent type, otherwise
    %   the input will be passed through unchanged.
    %
    %   See also castIntToFi, castFiToInt, cast64BitFiToInt
    
    % Copyright 2019 The MathWorks, Inc.
    
    %coder.inline('always');

    assertNeedOlderThanR2020a();
    
    if isa(u,'int64') || isa(u,'uint64')
        y = fi(u);
    else
        y = u;
    end
end
