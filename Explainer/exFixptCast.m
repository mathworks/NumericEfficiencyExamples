function r = exFixptCast(a,bLike)


    % Copyright 2019-2023 The MathWorks, Inc.

    nty = fixed.extractNumericType(bLike);

    r.yWrapFloor       = castWrapFloor(a,nty);
    r.yWrapZero        = castWrapZero(a,nty);
    r.yWrapCeil        = castWrapCeil(a,nty);
    r.yWrapNearTieInf  = castWrapNearTieInf(a,nty);
    r.yWrapNearTieAway = castWrapNearTieAway(a,nty);
    r.yWrapNearTieEven = castWrapNearTieEven(a,nty);

    r.ySatFloor       = castSatFloor(a,nty);
    r.ySatZero        = castSatZero(a,nty);
    r.ySatCeil        = castSatCeil(a,nty);
    r.ySatNearTieInf  = castSatNearTieInf(a,nty);
    r.ySatNearTieAway = castSatNearTieAway(a,nty);
    r.ySatNearTieEven = castSatNearTieEven(a,nty);
end


function y = castWrapFloor(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Wrap','RoundingMethod','Floor');
end

function y = castWrapZero(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Wrap','RoundingMethod','Zero');
end

function y = castWrapCeil(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Wrap','RoundingMethod','Ceiling');
end

function y = castWrapNearTieInf(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Wrap','RoundingMethod','Nearest');
end

function y = castWrapNearTieAway(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Wrap','RoundingMethod','Round');
end

function y = castWrapNearTieEven(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Wrap','RoundingMethod','Convergent');
end


function y = castSatFloor(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Floor');
end

function y =  castSatZero(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Zero');
end

function y =  castSatCeil(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Ceiling');
end

function y =  castSatNearTieInf(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Nearest');
end

function y =  castSatNearTieAway(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Round');
end

function y =  castSatNearTieEven(a,nty)
    
    coder.inline('never');

    y = fi(a,nty,'OverflowAction','Saturate','RoundingMethod','Convergent');
end
