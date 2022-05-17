function y = castToSymLossless(u)
%cast2symLossless convert any numeric or logical value to Symbolic Toolbox value

%   Copyright 2019 The MathWorks, Inc.

    if isa(u,'sym')
        y = u;
        return
    end

    nt = fixed.internal.type.extractNumericType(u);
    
    if ( isboolean(nt) || ...
            fixed.internal.type.isAnyFloat(nt) )
        u = double(u);
        y = sym(u,'f');
    else
        u = fixed.internal.math.castIntToFi(u);
        storedInteger = stripscaling(u);
        symQ = sym(storedInteger.Value);
        symBias = doubleToSymRatRecovery(nt.Bias);
        symSlope = getSlopeSym(nt);        
        y = ( symSlope * symQ ) + symBias;
    end
end

