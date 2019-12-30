function [intBits,fracBits] = getIntFracBitsForDisp(s,v)
    %getIntFracBitsForDisp get integer and fractional bits for display
    % using binary point format
    
    % Copyright 2019 The MathWorks, Inc.
    
    if v.isZero
        [intBits,fracBits] = binPtZero(s,v);
    else
        [intBits,fracBits] = binPtNonZero(s,v);
    end
end

function [intBits,fracBits] = binPtZero(s,v)
    % for binary point diplay of zero
    % get integer and fraction bits
    
    assert(v.isZero);
    assert(s.dispAttrib.useTrueBinPtDisp);
    
    if s.dispAttrib.binPtMaxPow2Wt >= 0
        intBits = '0';
        fracBits = '';
    else
        intBits = '';
        fracBits = '0';
    end
end

function [intBits,fracBits] = binPtNonZero(s,v)
    % binary point diplay of non-zero scalar
    %    get integer and fraction bits
    %
    
    neg = v.isNegative;
    
    fe = v.FixedExponent;
    maxPow2Wt = v.maxPow2Wt;
    
    bin = v.bin;
    
    gapMSEnd = -1 - maxPow2Wt;
    if gapMSEnd > 0
        if neg
            c = '1';
        else
            c = '0';
        end
        bin = [repmat(c,1,gapMSEnd), bin];
        maxPow2Wt = -1;
    elseif isPosInNegGroup(s,v)
        bin = ['0', bin];
        maxPow2Wt = maxPow2Wt + 1;
    end
    
    gapLSEnd = fe;
    if gapLSEnd > 0
        bin = [bin, repmat('0',1,gapLSEnd)];
    end
    
    %nBits = length(bin);
    idxLeftOfBinPt = maxPow2Wt + 1;
    fracBits = bin((idxLeftOfBinPt+1):end);
    intBits = bin(1:idxLeftOfBinPt);
end
