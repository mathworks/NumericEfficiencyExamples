function y = floatMantissaToFiWithExp(u)
    %floatMantissaToFiWithExp converting floating-point finite real scalar
    % to fixed-point with same word length as "signed mantissa"
    % and same scaling as implied by exponent
    % 
    
    % Copyright 2019-2020 The MathWorks, Inc.

    validateattributes(u, {'numeric','embedded.fi'},...
        {'real','finite','scalar'});
    
    nt = fixed.internal.type.extractNumericType(u);    
    assert(fixed.internal.type.isAnyFloat(nt));
    a = fixed.internal.type.attribFloatingPoint(nt);

    u = fixed.internal.math.castFiToMATLAB(u);    
    u = fixed.internal.math.castHalf2Single(u);
    
    wl = a.mantissaBitsEffective + 1;
    
    au = abs(u);
    if au < (2*a.realmin)
        fracLength = -a.log2Tiny;
        y = fi(u,1,wl,fracLength);
    else
        y = fi(au,1,wl);
        y(:) = u;
    end
end
