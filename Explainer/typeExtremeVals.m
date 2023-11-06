function y = typeExtremeVals(dt)
    % typeExtremeVals extreme values of type
    %   max finite representable
    %   min finite representable
    %   min Positive
    %   max Positive
    %   zero
    
    %   Copyright 2023 The MathWorks, Inc.

    nt = fixed.extractNumericType(dt);
    aUp = upperbound(nt);
    aLo = lowerbound(nt);
    aZero = fi(0,nt);
    aMinPos = fixed.internal.type.minPosFiniteRepresentableVal(nt);
    if isempty(aMinPos)
        aMinPos = aUp;
    end
    aMaxNeg = fixed.internal.type.maxNegFiniteRepresentableVal(nt);
    if isempty(aMaxNeg)
        aMaxNeg = aLo;
    end
    y = fliplr(fixed.internal.math.unique([aUp, aMinPos, aZero, aMaxNeg, aLo]));
end
