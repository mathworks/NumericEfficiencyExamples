function s = groupNumAttrib(s,v)
    %groupNumAttrib initialize (no inputs) or update group numeric attributes
    
    % Copyright 2019 The MathWorks, Inc.
    
    if nargin < 1
        % initial values
        
        s.anyNegative = false;
        s.anyNonZero = false;
        s.maxNonSignPow2Wt = -Inf;
        s.minPow2Wt = Inf;
        s.max_minPow2Wt = -Inf;
        s.maxPow2Wt = -Inf;
        s.maxPosBitSpan = 1;
        s.maxNegBitSpan = 2;
        s.maxBitSpan = [];
    elseif nargin > 1
        % update values
        assert(isfinite(v.tfi));
        
        bitSpan = v.WordLength;
        
        if ~v.isZero
            
            if v.isNegative
                s.anyNegative = true;
                s.maxNegBitSpan = max(s.maxNegBitSpan,bitSpan);
            else
                s.maxPosBitSpan = max(s.maxPosBitSpan,bitSpan);
            end
            
            s.anyNonZero = true;
            
            nonSignPow2Wt = v.maxPow2Wt - v.isNegative;
            s.maxNonSignPow2Wt = max( s.maxNonSignPow2Wt, nonSignPow2Wt);
            s.minPow2Wt = min( s.minPow2Wt, v.FixedExponent);
            s.max_minPow2Wt = max( s.max_minPow2Wt, v.FixedExponent);
        end
    else
        % Finalize
        % passing in only one argment means to finalize
        %
        if ~s.anyNonZero
            assert(~s.anyNegative);
            s.maxNonSignPow2Wt = 0;
            s.minPow2Wt = 0;
            s.max_minPow2Wt = 0;
        end
        s.maxPow2Wt = s.maxNonSignPow2Wt;
        if s.anyNegative
            s.maxPow2Wt = s.maxPow2Wt + 1;
            s.maxBitSpan = max( s.maxNegBitSpan, s.maxPosBitSpan+1);
        else
            s.maxBitSpan = s.maxPosBitSpan;
        end
        wl = s.maxPow2Wt + 1 - s.minPow2Wt;
        s.overcoatType = numerictype(s.anyNegative,wl,-s.minPow2Wt);
    end
end