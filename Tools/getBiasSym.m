function s = getBiasSym(u)
    %getBiasSym from type specified by input get its symbolic Bias
    %
    % Rational recovery, doubleToSymRatRecovery, will be applied to 
    % the Bias double value.
    %
    % For example, if Bias = 0.05000000000000000278,
    % then the recovered rational is 1/20
    %
    % Copyright 2019 The MathWorks, Inc.

    nt = fixed.internal.type.extractNumericType(u);
    
    s = doubleToSymRatRecovery( nt.Bias );        
end
