function s = groupNumAttrib(action,s,input2,input3,input4)
    %groupNumAttrib initialize, update, or finalize group numeric attributes
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    switch action
        case 'init'
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
            
        case 'update'
            % update values
            
            assert(isfinite(input2.minBitSpanFi));
            
            bitSpan = input2.WordLength;
            
            if ~input2.isZero
                
                if input2.isNegative
                    s.anyNegative = true;
                    s.maxNegBitSpan = max(s.maxNegBitSpan,bitSpan);
                else
                    s.maxPosBitSpan = max(s.maxPosBitSpan,bitSpan);
                end
                
                s.anyNonZero = true;
                
                nonSignPow2Wt = input2.maxPow2Wt - input2.isNegative;
                s.maxNonSignPow2Wt = max( s.maxNonSignPow2Wt, nonSignPow2Wt);
                s.minPow2Wt = min( s.minPow2Wt, input2.FixedExponent);
                s.max_minPow2Wt = max( s.max_minPow2Wt, input2.FixedExponent);
            end
            
        case 'finalize'
            % Finalize
            % passing in only one argment means to finalize
            %
            origTypes = input2;
            uNumeric = input3;
            nTot = input4;
            
            % Get type overcoat of all non-floating point original types
            %
            overcoat2 = origTypes{1};
            for iIn = 2:numel(origTypes)
                overcoat2 = dtPairToOvercoat(overcoat2,origTypes{iIn});
            end
            s.typeOvercoatOrigTypes = overcoat2;
            
            allValuesZero = ~s.anyNonZero;
            if allValuesZero
                assert(~s.anyNegative);
                
                haveNonFloatOrigType = ~isfloat(overcoat2);
                
                if haveNonFloatOrigType
                    % If any original type was not floating point
                    % choose a weighted bit column for zero
                    % that was in the original types
                    % and as close as possible to column 2^0
                    %
                    fe = s.Attrib.typeOvercoatOrigTypes.FixedExponent;
                    wl = s.Attrib.typeOvercoatOrigTypes.WordLength;
                    minPow2Wt = fe;
                    maxPow2Wt = wl - 1 + fe;
                    pow2Exp = max(min(0,maxPow2Wt),minPow2Wt);
                else
                    pow2Exp = 0;
                end
                s.maxNonSignPow2Wt = pow2Exp;
                s.minPow2Wt = pow2Exp;
                s.max_minPow2Wt = pow2Exp;
            end
            
            s.maxPow2Wt = s.maxNonSignPow2Wt;
            if s.anyNegative
                s.maxPow2Wt = s.maxPow2Wt + 1;
                s.maxBitSpan = max( s.maxNegBitSpan, s.maxPosBitSpan+1);
            else
                s.maxBitSpan = s.maxPosBitSpan;
            end
            wl = s.maxPow2Wt + 1 - s.minPow2Wt;
            s.typeOvercoatOfAllMinBitSpans = numerictype(s.anyNegative,wl,-s.minPow2Wt);
            
            s.valsInOvercoatType = castAllToType(s.typeOvercoatOfAllMinBitSpans,uNumeric,nTot);
            %
            % The following deals with the edge case of -2^n adding a needless
            % least significant bit column. For example, if the inputs values are
            % -2^1 and -2^0.  Then there would be a needless 2^-1 bit column so
            % far. This code will trim off that needless column.
            %
            s.valsInOvercoatType = fixed.internal.type.tightFi(s.valsInOvercoatType);
            s.typeOvercoatOfAllMinBitSpans = numerictype(s.valsInOvercoatType);
            s.minPow2Wt = s.typeOvercoatOfAllMinBitSpans.FixedExponent;
            
            s.typeOvercoatCombined = dtPairToOvercoat(...
                s.typeOvercoatOfAllMinBitSpans,...
                s.typeOvercoatOrigTypes);
    end
end
