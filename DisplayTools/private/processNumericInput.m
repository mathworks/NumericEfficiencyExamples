function [s,idx] = processNumericInput(s,idx,u)
    %processNumericInput process inputs to collect info for display
    
    % Copyright 2019-2020 The MathWorks, Inc.

    assert(isNumericOrlogical(u));

    n = numel(u);
    for j=1:n
        [s,idx] = processScalar(s,idx,u(j));
    end
end



function [s,idx] = processFiniteScalar(s,idx,u)
    
    assert(isfinite(u));
    
    ut = fixed.internal.type.tightFi(u);
    
    neg = 0 > ut;
    isZero = 0 == ut;
    fe = ut.FixedExponent;
    wl = ut.WordLength;
    maxPow2Wt = wl-1+fe;
        
    s.vals(idx).minBitSpanFi = ut;
    s.vals(idx).bin = ut.bin;
    s.vals(idx).FixedExponent = fe;
    s.vals(idx).WordLength = wl;
    s.vals(idx).maxPow2Wt = maxPow2Wt;
    s.vals(idx).isNegative = neg;
    s.vals(idx).isZero = isZero;
    
    s.Attrib = groupNumAttrib('update',s.Attrib,s.vals(idx));
        
    idx = idx+1;
end
   
    
function [s,idx] = processNonFiniteScalar(s,idx,u)
    
    assert(~isfinite(u));
    
    s.vals(idx).minBitSpanFi = u;
    s.vals(idx).bin = '';
    s.vals(idx).FixedExponent = [];
    s.vals(idx).maxPow2Wt = [];
    s.vals(idx).isNegative = [];
    s.vals(idx).isZero = [];
        
    idx = idx+1;
end


function [s,idx] = processScalar(s,idx,u)
    
    if isfinite(u)
        [s,idx] = processFiniteScalar(s,idx,u);
    else
        [s,idx] = processNonFiniteScalar(s,idx,u);
    end
end
