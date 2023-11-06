function roundRoundingExamples(ntu,nty)


    % Copyright 2019-2023 The MathWorks, Inc.

    yZero = fi(0,nty);    
    
    slopeRatio = nty.Slope/ntu.Slope;

    if slopeRatio <= 1
        deltaC = {
            0,  'Rounding never needed'
            -1, 'Rounding never needed'
            };
    elseif slopeRatio == 2
        deltaC = {
            -0.5, 'Rounding only at mid-point, rounds to even'
            -1.5, 'Rounding only at mid-point, rounds to even'
            };        
    else        
        deltaC = {
            -1.5,                'Negative at mid-point, round down'
            -0.5,                'Positive at mid-point, round up'
            -0.5-(1/slopeRatio), 'Below mid-point, round down'
            -0.5+(1/slopeRatio), 'Above mid-point, round up'
            };
    end

    utilRoundingExamples(ntu,nty,'Round',yZero,deltaC)
end


