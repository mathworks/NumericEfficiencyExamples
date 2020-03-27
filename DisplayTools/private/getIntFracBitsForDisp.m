function [intBits,fracBits] = getIntFracBitsForDisp(s,v)
    %getIntFracBitsForDisp get integer and fractional bits for display
    % using binary point format
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    extendRangeGiveSpaces = ~s.opt.extendRange;
    extendPrecisionGiveSpaces = ~s.opt.extendPrecision;
    
    curVal = getValBasedOnOption(s,v);
    
    lo = s.Attrib.minPow2Wt;
    hi = s.Attrib.maxPow2Wt;
    
    if lo <= -1
        fracBits = numericDispUtil.getBitOverPow2Range(curVal,...
            lo,...
            -1,...
            false,extendPrecisionGiveSpaces);
    else
        fracBits = '';
    end
    if 0 <= hi
        intBits = numericDispUtil.getBitOverPow2Range(curVal,...
            0,...
            hi,...
            extendRangeGiveSpaces,false);
    else
        intBits = '';
    end
end


