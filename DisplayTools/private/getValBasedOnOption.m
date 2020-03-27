function curVal = getValBasedOnOption(s,v)

    % Copyright 2019-2020 The MathWorks, Inc.

    useType = s.opt.InType;
    if useType
        curVal = v.valBinPtTypeBasedOnOrigType;
    else
        curVal = v.minBitSpanBinPt;
    end
    if s.Attrib.anyNegative && ('1' == curVal.bin(1))
        curVal = fi(curVal,fixed.internal.type.sproutSignBit(curVal));
    end
end
