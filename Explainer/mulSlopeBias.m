function y = mulSlopeBias(a,b)


    % Copyright 2019-2023 The MathWorks, Inc.

    nta = fixed.extractNumericType(a);
    ntb = fixed.extractNumericType(b);

    if ~nta.isslopebiasscaled && ~ntb.isslopebiasscaled
        y = a .* b;
    else
        a2 = castToNoBias(a);
        b2 = castToNoBias(b);
    
        a3 = stripscaling(a2);
        b3 = stripscaling(b2);

        y2 = a3 .* b3;

        nty = fixed.internal.type.copyNewScaling(...
            y2.numerictype,...
            nta.Slope * ntb.Slope, 0 );

        y = reinterpretcast(y2,nty);
    end
end