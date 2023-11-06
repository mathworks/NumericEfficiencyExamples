function ceilRoundingExamples(ntu,nty)


    % Copyright 2019-2023 The MathWorks, Inc.

    slopeRatio = nty.Slope/ntu.Slope;

    if slopeRatio <= 1
        deltaC = {
            0, 'Rounding never needed'
            -1, 'Rounding never needed'
            };
    elseif slopeRatio == 2
        deltaC = {
            -0.5, 'Everything rounds up'
            };        
    else        
        deltaC = {
            -1+(1/slopeRatio), 'Everything rounds up'
             0-(1/slopeRatio), 'Everything rounds up'
            };
    end

    yHi = upperbound(nty);    

    utilRoundingExamples(ntu,nty,'Ceiling',yHi,deltaC)
end


