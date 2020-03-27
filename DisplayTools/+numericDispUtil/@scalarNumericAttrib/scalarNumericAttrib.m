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
        function obj = scalarNumericAttrib(u,opt)
            %scalarNumericAttrib Construct an instance of this class
            %
            assert(numericDispUtil.isNumericOrlogical(u));

            obj = processScalar(obj,u,opt);
        end
    end
end

function obj = processFiniteScalar(obj,u,opt)
    
    assert(isfinite(u));
    obj.valIsFinite = true;
    
    u = fixed.internal.math.castIntToFi(u);
    uNoSlopeBias = fixed.internal.math.fullSlopeBiasToBinPt(u);
    ut = tightFiScalarCached(uNoSlopeBias);

    if ( 2 == ut.WordLength && ut.SignednessBool && ...
         (-1 > ut.FixedExponent) && strcmp(ut.bin,'10') && ...
         strcmp(opt.preferFormat,'BinPt') )
       ut = fi(ut,1,2,-(ut.FixedExponent+1));
    end   
    
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

function obj = processScalar(obj,u,opt)
    
    obj.origValue = u;
    obj.origType = getInputType(u);
    
    if isfinite(u)
        obj = processFiniteScalar(obj,u,opt);
    end
end

function dt = getInputType(u)
   dt = fixed.internal.type.extractNumericType(u); 
   dt = fixed.internal.type.changeLogicalToUfix1(dt);
end
