function [s,idx] = processNumericInput(s,idx,u)
    %processNumericInput process inputs to collect info for display
    
    % Copyright 2019 The MathWorks, Inc.

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
        
    s.v(idx).tfi = ut;
    s.v(idx).bin = ut.bin;
    s.v(idx).FixedExponent = fe;
    s.v(idx).WordLength = wl;
    s.v(idx).maxPow2Wt = maxPow2Wt;
    s.v(idx).isNegative = neg;
    s.v(idx).isZero = isZero;
    
    s.Attrib = groupNumAttrib(s.Attrib,s.v(idx));
        
    idx = idx+1;
end
   
    
function [s,idx] = processNonFiniteScalar(s,idx,u)
    
    assert(~isfinite(u));
    
    s.v(idx).tfi = u;
    s.v(idx).bin = '';
    s.v(idx).FixedExponent = [];
    s.v(idx).maxPow2Wt = [];
    s.v(idx).isNegative = [];
    s.v(idx).isZero = [];
        
    idx = idx+1;
end


function [s,idx] = processScalar(s,idx,u)
    
    if isfinite(u)
        [s,idx] = processFiniteScalar(s,idx,u);
    else
        [s,idx] = processNonFiniteScalar(s,idx,u);
    end
end
