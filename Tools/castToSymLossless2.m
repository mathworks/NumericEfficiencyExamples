function y = castToSymLossless2(u)
%cast2symLossless2 convert any numeric or logical value to Symbolic Toolbox value
%
% The conversion treats the value of SlopeAdjustmentValue and Bias 
% as they are stored in double precision as "the truth"
% There is no attempt to do rational recovery
%

%   Copyright 2019-2020 The MathWorks, Inc.

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
        symBias = sym(nt.Bias,'f');
        symSlope = sym(nt.SlopeAdjustmentFactor,'f')*2.^sym(nt.FixedExponent);
        y = ( symSlope * symQ ) + symBias;
    end
end

