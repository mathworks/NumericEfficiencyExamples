function y = sumReduceSlopeBias(a)


    % Copyright 2019-2023 The MathWorks, Inc.

    nta = fixed.extractNumericType(a);

    if ~nta.isslopebiasscaled
        y = sum(a(:));
    else   
        a3 = stripscaling(a);

        y2 = sum(a3(:));

        nty = fixed.internal.type.copyNewScaling(...
            y2.numerictype,...
            nta.Slope, ...
            numel(a)*nta.Bias);

        y = reinterpretcast(y2,nty);
    end
end