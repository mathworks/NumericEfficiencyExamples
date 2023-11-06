function r = castStats(ntu,nty,roundingMethod)


    % Copyright 2019-2023 The MathWorks, Inc.

    r = struct();

    ntu = fixed.extractNumericType(ntu);
    nty = fixed.extractNumericType(nty);
    
    rndTerms = roundingAddTerm(nty,roundingMethod);

    r = overflowHi(r,rndTerms,ntu,nty);
    r = overflowLo(r,rndTerms,ntu,nty);

    r.overflowCountTot = r.overflowCountHi + r.overflowCountLo;
    r.cardinalityTot = r.cardinalityLo + r.cardinalityHi;

    if r.overflowCountTot == 0
        r.overflowRatioTot = 0;
    else
        r.overflowRatioTot = double(r.overflowCountTot) / double(r.cardinalityTot);
    end
end


function r = roundingAddTerm(nty,roundingMethod)

    slope = fixed.internal.type.tightSlope(nty);
    halfSlope = fixed.internal.math.fiHalf * slope;
    zero = fixed.internal.math.fiZero;

    switch roundingMethod
        case {'Convergent', 'Nearest'}
            r.upDelta = halfSlope;
            r.upOverflows = true;
            r.dnDelta = halfSlope;
            r.dnOverflows = false;

        case 'Round'
            % Need more thought here
            % for representable values all left or all right of zero
            %
            r.upDelta = halfSlope;
            r.upOverflows = true;
            r.dnDelta = halfSlope;
            r.dnOverflows = true;

        case 'Floor'
            r.upDelta = slope;
            r.upOverflows = true;
            r.dnDelta = zero;
            r.dnOverflows = false;

        case 'Zero'
            % Need more thought here
            % for representable values all left or all right of zero
            %
            r.upDelta = slope;
            r.upOverflows = true;
            r.dnDelta = slope;
            r.dnOverflows = true;

        case 'Ceiling'
            r.upDelta = zero;
            r.upOverflows = false;
            r.dnDelta = slope;
            r.dnOverflows = true;
    end
end


function r = overflowHi(r,rndTerms,ntu,nty)

    uHi = fixed.internal.type.maxFiniteRepresentableVal(ntu);
    yHi = fixed.internal.type.maxFiniteRepresentableVal(nty);
    
    yHi = fixed.internal.math.fullSlopeBiasToBinPt(yHi);

    overThreshold = yHi + rndTerms.upDelta;

    yRelop = fixed.internal.math.fullPrecisionRelop(uHi,overThreshold);

    if rndTerms.upOverflows
        overflowCanOccur = yRelop.ge;
        endNotes = '[]';
    else
        overflowCanOccur = yRelop.gt;
        endNotes = '(]';
    end

    if ~overflowCanOccur
        r.overflowCountHi = 0;
    else
        fiInterval = fixed.Interval(overThreshold,uHi,endNotes);

        r.overflowCountHi = ...
            fixed.internal.utility.cardinality.getCardinality(fiInterval, ntu);
    end

    % Need more thought here
    % for representable values all left or all right of zero
    %
    fiInterval = fixed.Interval(0,uHi,'[]');    
    r.cardinalityHi = ...
        fixed.internal.utility.cardinality.getCardinality(fiInterval, ntu);    

    if ~overflowCanOccur
        r.overflowRatioHi = 0;
    else
        r.overflowRatioHi = double(r.overflowCountHi) / double(r.cardinalityHi);
    end
end

function r = overflowLo(r,rndTerms,ntu,nty)

    uLo = fixed.internal.type.minFiniteRepresentableVal(ntu);
    yLo = fixed.internal.type.minFiniteRepresentableVal(nty);

    yLo = fixed.internal.math.fullSlopeBiasToBinPt(yLo);

    fiMinusOne = fixed.internal.math.fiMinusOne;

    overThreshold = yLo + fiMinusOne * rndTerms.dnDelta;

    yRelop = fixed.internal.math.fullPrecisionRelop(uLo,overThreshold);

    if rndTerms.dnOverflows
        overflowCanOccur = yRelop.le;
        endNotes = '[]';
    else
        overflowCanOccur = yRelop.lt;
        endNotes = '[)';
    end

    if ~overflowCanOccur
        r.overflowCountLo = 0;
    else
        fiInterval = fixed.Interval(uLo,overThreshold,endNotes);

        r.overflowCountLo = ...
            fixed.internal.utility.cardinality.getCardinality(fiInterval, ntu);
    end    
    % Need more thought here
    % for representable values all left or all right of zero
    %
    fiInterval = fixed.Interval(uLo,0,'[)');    
    r.cardinalityLo = ...
        fixed.internal.utility.cardinality.getCardinality(fiInterval, ntu);    

    if ~overflowCanOccur
        r.overflowRatioLo = 0;
    else
        r.overflowRatioLo = double(r.overflowCountLo) / double(r.cardinalityLo);
    end
end
