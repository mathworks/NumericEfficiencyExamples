classdef scalarNumericAttrib
    %scalarNumericAttrib Summary of this class goes here
    
    properties
        origValue = [];
        origType = [];
        valIsFinite = false;
        minBitSpanBinPt = [];
        valBinPtTypeBasedOnOrigType = [];
        bin = '';
        FixedExponent = [];
        WordLength = [];
        maxPow2Wt = [];
        maxPow2WtPositive = [];
        maxPow2WtNegative = [];
        minPow2Wt = [];
        isNegative = [];
        isZero = [];
    end
    
    methods
        function obj = scalarNumericAttrib(u)
            %scalarNumericAttrib Construct an instance of this class
            %
            assert(numericDispUtil.isNumericOrlogical(u));

            obj = processScalar(obj,u);
        end
    end
end

function obj = processFiniteScalar(obj,u)
    
    assert(isfinite(u));
    obj.valIsFinite = true;
    
    u = fixed.internal.math.castIntToFi(u);
    uNoSlopeBias = fixed.internal.math.fullSlopeBiasToBinPt(u);
    ut = tightFiScalarCached(uNoSlopeBias);

    
    obj.minBitSpanBinPt = ut;
    obj.bin = ut.bin;

    if fixed.internal.type.isAnyFloat(obj.origType)
        obj.valBinPtTypeBasedOnOrigType = numericDispUtil.floatMantissaToFiWithExp(obj.origValue);
    else
        obj.valBinPtTypeBasedOnOrigType = uNoSlopeBias;
    end
    
    obj = numericDispUtil.getBinPtPow2ColInfo(ut,obj);
    
    obj.isNegative = 0 > ut;
    obj.isZero = 0 == ut;
end

function obj = processScalar(obj,u)
    
    obj.origValue = u;
    obj.origType = getInputType(u);
    
    if isfinite(u)
        obj = processFiniteScalar(obj,u);
    end
end

function dt = getInputType(u)
   dt = fixed.internal.type.extractNumericType(u); 
   dt = fixed.internal.type.changeLogicalToUfix1(dt);
end
