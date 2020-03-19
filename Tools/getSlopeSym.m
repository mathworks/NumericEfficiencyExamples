function s = getSlopeSym(u)
    %getSlopeSym from type specified by input get its symbolic Slope
    %
    % Rational recovery, doubleToSymRatRecovery, will be applied to 
    % the Slope double value.
    %
    % For example, if Slope = 0.05000000000000000278,
    % then the recovered rational is 1/20
    %
    % Copyright 2019 The MathWorks, Inc.

    nt = fixed.internal.type.extractNumericType(u);
    
    f = nt.SlopeAdjustmentFactor;
    fe = nt.FixedExponent;
    
    a = fixed.internal.type.attribFloatingPoint('double');
    
    feHi = a.exponentRealWorldValueMax;
    feLo = a.exponentRealWorldValueMin;
    
    feLim = min(feHi, max( feLo, fe ) );
   
    feChange = fe - feLim;
    
    s = doubleToSymRatRecovery( f * (2^feLim) ) * sym( 2^feChange );        
end
