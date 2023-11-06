function y = exFixptCastSatFloor(a,bLike)
    

    % Copyright 2019-2023 The MathWorks, Inc.

    nty = fixed.extractNumericType(bLike);

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Floor');
end
