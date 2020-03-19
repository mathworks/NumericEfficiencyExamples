function [S,B,Q] = getScaleTerms(u,suffix,verbose)
    %getScaleTerms helper to get symbolic scaling terms
    
    % Copyright 2019 The MathWorks, Inc.

    if ~isempty(u)
        nt = fixed.internal.type.extractNumericType(u);
        S = getSlopeSym(nt);
        B = getBiasSym(nt);
    else
        if verbose
            S = ['Slope',suffix];
            B  = ['Bias',suffix];
        else
            S = ['S',suffix];
            B = ['B',suffix];
        end
    end
    if verbose
        Q = ['StoredInteger',suffix];
    else
        Q = ['Q',suffix];
    end    
end
