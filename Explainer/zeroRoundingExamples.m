function zeroRoundingExamples(ntu,nty)


    % Copyright 2019-2023 The MathWorks, Inc.

    yZero = fi(0,nty);    

    slopeRatio = nty.Slope/ntu.Slope;

    if slopeRatio <= 1
        deltaC = {
            0, 'Rounding never needed'
            -1, 'Rounding never needed'
            };
    elseif slopeRatio == 2
        deltaC = {
            -0.5, 'Negatives rounds up'
             0.5, 'Positives round down'
            };        
    else        
        deltaC = {
           -2+(1/slopeRatio), 'Negatives rounds up'
           -1-(1/slopeRatio), 'Negatives rounds up'
            1+(1/slopeRatio), 'Positives round down'
            2-(1/slopeRatio), 'Positives round down'
            };
    end

    utilRoundingExamples(ntu,nty,'Zero',yZero,deltaC)
end


