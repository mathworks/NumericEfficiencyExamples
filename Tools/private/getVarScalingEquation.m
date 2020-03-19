function symEq = getVarScalingEquation(u,suffixStoredInt,suffixScaling) 
    %getVarScalingEquation helper to get scaling equation of input
    
    % Copyright 2019 The MathWorks, Inc.

    if isempty(u)
        if ~exist('suffixScaling','var')
            suffixScaling = suffixStoredInt;
        end
        symEq = suffixToScalingEquation(suffixStoredInt,suffixScaling);
    else
        uSym = ['Q',suffixStoredInt];
        uSym = sym(uSym);
        symEq = getScalingEquationSym(u,uSym);
    end
end
