function r = getBinPtPow2ColInfo(u,objToSetOn)
    %getBinPtPow2ColInfo get info on power of 2 columns of a binary point type 
    
    % Copyright 2019-2020 The MathWorks, Inc.

    if exist('objToSetOn','var')
        r = objToSetOn;
    end
    
    nt = fixed.internal.type.extractIntFixedType(u);
    assert(fixed.internal.type.isTrivialSlopeAdjustBias(nt));
    
    fe = nt.FixedExponent;
    wl = nt.WordLength;
    isSigned = nt.SignednessBool;
    maxPow2WtCurVal = wl-1+fe;

    r.FixedExponent = fe;
    r.WordLength = wl;

    r.maxPow2Wt = maxPow2WtCurVal;
    bits = u.bin;
    if u < 0
        r.maxPow2WtPositive = [];
        r.maxPow2WtNegative = utilAdjustExponent(maxPow2WtCurVal,bits,true);
    else
        r.maxPow2WtPositive = utilAdjustExponent(maxPow2WtCurVal,bits,false);
        r.maxPow2WtNegative = [];
    end
    r.minPow2Wt = fe;    
end

function eCur = utilAdjustExponent(eCur,bits,isNeg)
    if isNeg
        bitMatch = '0';
        nOffset = 2;
    else
        bitMatch = '1';
        nOffset = 1;
    end
    
    ii = strfind(bits,bitMatch);
    if ~isempty(ii)
        nAdjust = ii(1) - nOffset;
        nBits = numel(bits);
        maxAdjust = nBits - nOffset;
        nAdjust = min(nAdjust,maxAdjust);
        nAdjust = max(nAdjust,0);
        eCur = eCur - nAdjust;
    end
end
