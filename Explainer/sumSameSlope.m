function y = sumSameSlope(a,b)


    % Copyright 2019-2023 The MathWorks, Inc.

    nta = fixed.extractNumericType(a);
    ntb = fixed.extractNumericType(b);

    if ~nta.isslopebiasscaled && ~ntb.isslopebiasscaled
        y = a .* b;
    else
        assert(nta.Slope == ntb.Slope)
    
        a3 = stripscaling(a);
        b3 = stripscaling(b);

        y2 = a3 + b3;

        nty = fixed.internal.type.copyNewScaling(...
            y2.numerictype,...
            nta.Slope, ...
            nta.Bias + ntb.Bias);

        y = reinterpretcast(y2,nty);
    end
end