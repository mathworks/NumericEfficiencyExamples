function y = getExtremeValues(nt,extraValues)


    % Copyright 2019-2023 The MathWorks, Inc.

    nt = fixed.extractNumericType(nt);

    bUp = upperbound(nt);
    bLo = lowerbound(nt);

    bZero = fi(0,nt);

    bMinPos = fixed.internal.type.minPosFiniteRepresentableVal(nt);
    if isempty(bMinPos)
        bMinPos = bUp;
    end

    bMaxNeg = fixed.internal.type.maxNegFiniteRepresentableVal(nt);
    if isempty(bMaxNeg)
        bMaxNeg = bLo;
    end
    
    numExtra = numel(extraValues);

    vec = [repmat(bUp,[1,3*numExtra]), bUp, bMinPos, bZero, bMaxNeg, bLo];

    for i=1:numExtra
        v = fi(extraValues(i),nt);
        vec(i*3-2) = v;
        vec(i*3-1) = fixed.internal.math.nextFiniteRepresentable(v);
        vec(i*3  ) = fixed.internal.math.prevFiniteRepresentable(v);
    end

    y = fliplr(fixed.internal.math.unique(vec));
end
