function nearestRoundingExamples(ntu,nty)


    % Copyright 2019-2023 The MathWorks, Inc.

    slopeRatio = nty.Slope/ntu.Slope;

    if slopeRatio <= 1
        deltaC = {
            0, 'Rounding never needed'
            -1, 'Rounding never needed'
            };
    elseif slopeRatio == 2
        deltaC = {
            -0.5, 'Rounding only at mid-point, rounds up'
            };        
    else        
        deltaC = {
            -0.5-(1/slopeRatio), 'Below mid-point, round down'
            -0.5,                'At mid-point, round up'
            -0.5+(1/slopeRatio), 'Above mid-point, round up'
            };
    end

    yHi = upperbound(nty);    

    utilRoundingExamples(ntu,nty,'Nearest',yHi,deltaC)
end


