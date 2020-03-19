function s = compactButAccurateDecStr(u)
    %compactButAccurateDecStr get value as a decimal string
    %with enough digits for lossless round trip eval back to 
    % double and/or to the original type.
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    validateattributes(u, {'numeric','embedded.fi','logical'},...
        {'real','scalar'});
    
    if isfinite(u)
        u = fixed.internal.math.castFiToMATLAB(u);
        u = fixed.internal.math.castIntToFi(u);
        if isfi(u)
            s = handleFi(u);
        else
            s = fixed.internal.compactButAccurateNum2Str(double(u));
        end
    else
        s = mat2str(double(u));
    end
end

function s = handleFi(u)    
    % get real world value of fi object
    % with enough digits for lossless round trip eval back to 
    % double or to the same fi type.
    %        
    wl = u.WordLength;
    n = max(wl,54);
    minDigits = ceil(log10(2^n));    
    s = mat2str(u,minDigits);
end
