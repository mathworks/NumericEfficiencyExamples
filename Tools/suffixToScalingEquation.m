function symEq = suffixToScalingEquation(suffixStoredInt,suffixScaling)
    %suffixToScalingEquation get fixed-point scaling equation with specifed suffix
    %
    % Usage
    %   symEq = suffixToScalingEquation(suffix,verbose)
    % Input
    %   suffixStoredInt  is a char or string
    %   suffixScaling  is a char or string
    %
    % Examples: 
    %   eq1 = suffixToScalingEquation('_U3')
    %      B_U3 + Q_U3*S_U3
    %
    %   eq2 = suffixToScalingEquation("67",true)
    %      Bias67 + Slope67*StoredInteger67
    
    % Copyright 2019 The MathWorks, Inc.

    suffixStoredInt = convertStringsToChars(suffixStoredInt);
    suffixScaling = convertStringsToChars(suffixScaling);
    
    q = ['Q',suffixStoredInt];
    s = ['S',suffixScaling];
    b = ['B',suffixScaling];

    symEq = (sym(q) * sym(s)) + sym(b);
end
