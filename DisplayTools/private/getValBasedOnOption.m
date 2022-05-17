function curVal = getValBasedOnOption(s,v)

    % Copyright 2019-2020 The MathWorks, Inc.

    useType = s.opt.InType;
    if useType
        curVal = v.valBinPtTypeBasedOnOrigType;
    else
        curVal = v.minBitSpanBinPt;
    end
    if s.Attrib.anyNegative && ('1' == curVal.bin(1))
        temp = fixed.internal.type.sproutSignBit(curVal);
        nt = numerictype(temp);
        curVal = fi(curVal,nt);
    end
end
