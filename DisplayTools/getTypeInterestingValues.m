function v = getTypeInterestingValues(nt,extraValuesWithNeighbors,extraSoloValues)
    %getTypeInterestingValues for the input type get vector of interesting values
    %
    % Example:
    % dispTypeAttrib(numerictype(1,3,1))
      
    % Copyright 2021 The MathWorks, Inc.
    
    nt = fixed.internal.type.extractNumericType(nt);
    
    cardInfo = fixed.internal.type.getTypeCardinality(nt);
    
    minFin = fixed.internal.type.minFiniteRepresentableVal(nt);
    
    if cardInfo.cardinalityLog2Ceil <= 3
        
        nPts = cardInfo.cardinalityExact;
        v = repmat(minFin,nPts,1);
        
        for i=2:nPts
            v(i) = fixed.internal.math.nextFiniteRepresentable(v(i-1));
        end
    else
        if ~exist('extraValuesWithNeighbors','var')
            extraValuesWithNeighbors = [];
        else
            extraValuesWithNeighbors = extraValuesWithNeighbors(:);
        end
        nExtraValuesWithNeighbors = numel(extraValuesWithNeighbors);
        
        if ~exist('extraSoloValues','var')
            extraSoloValues = [];
        else
            extraSoloValues = extraSoloValues(:);
        end
        nExtraSoloValues = numel(extraSoloValues);
        
        nPts = 30 + (3*nExtraValuesWithNeighbors) + nExtraSoloValues;
        
        v = repmat(minFin,nPts,1);
        
        i = 2;
        [v,i] = setValI(v,i,fixed.internal.math.nextFiniteRepresentable(minFin));
        
        vZero = fixed.internal.math.castUniversal(0,nt);
        [v,i] = setValWithI(v,i,vZero,true);
        
        maxFin = fixed.internal.type.maxFiniteRepresentableVal(nt);
        [v,i] = setValI(v,i,fixed.internal.math.prevFiniteRepresentable(maxFin));
        [v,i] = setValI(v,i,maxFin);
        
        if fixed.internal.type.isAnyFloatOrScaledDouble(nt)
            [v,i] = setValI(v,i,fixed.internal.math.castUniversal(inf,nt));
            [v,i] = setValI(v,i,fixed.internal.math.castUniversal(-inf,nt));
            [v,i] = setValI(v,i,fixed.internal.math.castUniversal(nan,nt));
        end

        if fixed.internal.type.isAnyFloat(nt)
           
            floatAttrib = fixed.internal.type.attribFloatingPoint(nt);
            realMin = fixed.internal.math.castUniversal(floatAttrib.realmin,nt);
            [v,i] = setValWithI(v,i,realMin);
        end        
        
        for j = 1:nExtraValuesWithNeighbors
            vCur = fixed.internal.math.castUniversal(extraValuesWithNeighbors(j),nt);
            [v,i] = setValWithI(v,i,vCur);
        end    
        
        for j = 1:nExtraSoloValues
            vCur = fixed.internal.math.castUniversal(extraSoloValues(j),nt);
            [v,i] = setValI(v,i,vCur);
        end    
        
        v = fixed.internal.math.unique(v);
    end
end

function [v,i] = setValI(v,i,u)
   
    assert(i <= numel(v));
    
    v(i) = u;
    i = i + 1;    
end

function [v,i] = setValWithI(v,i,u,X2)
    % set value and next and previous values
   
    if ~exist('X2','var')
        X2 = false;
    end
    
    prevV = fixed.internal.math.prevFiniteRepresentable(u);
    nextV = fixed.internal.math.nextFiniteRepresentable(u);
    
    if X2
        [v,i] = setValI(v,i,fixed.internal.math.prevFiniteRepresentable(prevV));
    end
    [v,i] = setValI(v,i,prevV);
    [v,i] = setValI(v,i,u);
    [v,i] = setValI(v,i,nextV);
    if X2
        [v,i] = setValI(v,i,fixed.internal.math.nextFiniteRepresentable(nextV));
    end
end

