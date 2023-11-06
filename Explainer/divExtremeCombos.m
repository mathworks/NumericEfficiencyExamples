function [yExtreme,aExtreme,bExtreme] = divExtremeCombos(nta,ntb)

    % Copyright 2019-2023 The MathWorks, Inc.

    nta = fixed.extractNumericType(nta);
    ntb = fixed.extractNumericType(ntb);

    aExtreme = typeExtremeValsForDiv(nta, 1);
    bExtreme = typeExtremeValsForDiv(ntb, 0);

    temp = aExtreme(1) ./ bExtreme(1);
    nty = fixed.extractNumericType(temp);
    nty = fixed.internal.type.growRangeBits(nty,4);
    nty = fixed.internal.type.growPrecisionBits(nty,40);

    [aExtreme,bExtreme] = meshgrid(aExtreme,bExtreme);
    aExtreme = aExtreme(:);
    bExtreme = bExtreme(:);

    fm = fimath('RoundingMethod', 'Zero', ...
        'OverflowAction', 'Wrap');

    yExtreme = removefimath(...
        nty.divide(...
        setfimath(aExtreme,fm),...
        setfimath(bExtreme,fm)));

    yExtreme = fixed.internal.type.tightFi(yExtreme);
    nty = numerictype(yExtreme);

    [yExtreme,iiSort] = sort(yExtreme);
    aExtreme = aExtreme(iiSort);
    bExtreme = bExtreme(iiSort);

    iiDup = [false; yExtreme(1:(end-1)) == yExtreme(2:end)];

    yExtreme(iiDup) = [];

    minDiff = min(diff(double(yExtreme)));

    fTemp = fixed.internal.type.tightFi(fi(minDiff,0,2));

    yChange = false;

    nDrop = nty.FractionLength - fTemp.FractionLength;
    if nDrop > 0
        yChange = true;
        nty = fixed.internal.type.growPrecisionBits(nty,-nDrop);
    end

    wlv = [32,64,128];
    wlContainer = wlv( find(nty.WordLength <= wlv,1,'first') );

    nAdd = wlContainer - nty.WordLength;
    if nAdd > 0
        yChange = true;
        nty = fixed.internal.type.growPrecisionBits(nty,nAdd);
    end

    if yChange
        yExtreme = removefimath(...
            nty.divide(...
            setfimath(aExtreme,fm),...
            setfimath(bExtreme,fm)));

        [yExtreme,iiSort] = sort(yExtreme);
        aExtreme = aExtreme(iiSort);
        bExtreme = bExtreme(iiSort);

        iiDup = [false; yExtreme(1:(end-1)) == yExtreme(2:end)];

        yExtreme(iiDup) = [];
    end

    aExtreme(iiDup) = [];
    bExtreme(iiDup) = [];

    nPts = numel(yExtreme);

    %[yMax,iMax] = max(yExtreme);
    %[yMin,iMin] = min(yExtreme);

    iZero = find(yExtreme >= 0, 1, 'first');

    % temp = yExtreme;
    % temp(yExtreme <= 0) = yMax;
    % [~,iNZP] = min(temp);
    % temp = yExtreme;
    % temp(yExtreme >= 0) = yMin;
    % [~,iNZN] = max(temp);
    %
    % [~,iMinDiff] = min(diff(double(yExtreme)));
    %
    % iKeep = unique([iMax, iMin, iNZP, iNZN, iMinDiff, iMinDiff+1]);

    iKeep = unique([1:2, (iZero+(-1:3)), nPts-1, nPts]);
    iKeep(iKeep<1) = [];
    iKeep(iKeep>nPts) = [];

    yExtreme = yExtreme(iKeep);
    aExtreme = aExtreme(iKeep);
    bExtreme = bExtreme(iKeep);

    [yExtreme,iiSort] = sort(yExtreme);
    aExtreme = aExtreme(iiSort);
    bExtreme = bExtreme(iiSort);
end

function y = typeExtremeValsForDiv(nty, includeZero)
    % typeExtremeVals extreme values of type for div

    aUp = upperbound(nty);

    y = repmat(aUp,1,11);
    i = 2;

    y(i) = fixed.internal.math.prevFiniteRepresentable(aUp);
    i = i+1;

    aLo = lowerbound(nty);
    y(i) = aLo;
    i = i+1;

    y(i) = fixed.internal.math.nextFiniteRepresentable(aUp);
    i = i+1;

    aZero = fi(0,nty);
    y(i) = aZero;
    i = i+1;

    tempP = aZero;
    tempN = aZero;
    for j=1:3
        tempP = fixed.internal.math.nextFiniteRepresentable(tempP);
        y(i) = tempP;
        i = i+1;
        tempN = fixed.internal.math.prevFiniteRepresentable(tempN);
        y(i) = tempN;
        i = i+1;
    end

    y = fixed.internal.math.unique(y);

    if ~includeZero
        y(y==0) = [];
    end

end
