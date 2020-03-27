classdef groupNumericAttrib2
    %groupNumericAttrib
    
    properties
        anyFinite = false;
        anyNonFinite = false;
        anyNegative = false;
        anyNonZero = false;
        
        % The following data is about tight representations
        %
        maxPow2Wt = -Inf;
        maxPow2WtPositive = -Inf;
        maxPow2WtNegative = -Inf;
        max_minPow2Wt = -Inf;
        minPow2Wt = Inf;
        
        % The following data is about individual tight representations
        %
        maxPosBitSpan = 1;
        maxNegBitSpan = 2;
        maxBitSpan = [];
        
        % Options
        opt = [];
        
        % original numeric inputs
        uNumeric = [];
        origTypes = [];
        nTot = 0;
        
        % Individual values
        vals = [];
    end
    
    methods
        function obj = groupNumericAttrib2(varargin)
            %groupNumericAttrib2 Construct an instance of this class
            [obj.opt,obj.uNumeric] = numericDispUtil.splitOptionsFromNumerics(varargin{:});
            obj.opt = setDefaultOptions(obj.opt);

            obj.nTot = numericDispUtil.getNumRealScalars(obj.uNumeric{:});
            obj = setOrigInputTypes(obj);            
            
            initVal = numericDispUtil.scalarNumericAttrib(inf,obj.opt);
            obj.vals = repmat(initVal,obj.nTot,1);
            obj = setValScalars(obj);
            
            obj = setGroupProps(obj);
        end
     end
end

function opt = setDefaultOptions(opt)

    defOpt.maxDispWidthBits = 80;
    defOpt.preferFormat = '';
    defOpt.InType = false;
    defOpt.extendRange = false;
    defOpt.extendPrecision = false;
    
    assert(~isempty(opt))
    fns = fieldnames(defOpt);
    for i=1:numel(fns)
        fn = fns{i};
        if ~isfield(opt,fn)
            opt.(fn) = defOpt.(fn);
        end
    end
end


function dt = getInputType(u)
   dt = fixed.internal.type.extractNumericType(u); 
   dt = fixed.internal.type.changeLogicalToUfix1(dt);
end


function obj = setValScalars(obj)
    
    nNumeric = numel(obj.uNumeric);
    idxScalar = 1;
    for iIn = 1:nNumeric
        u = obj.uNumeric{iIn};
        n = numel(u);
        for j=1:n
            obj.vals(idxScalar) = numericDispUtil.scalarNumericAttrib(u(j),obj.opt);
            idxScalar = idxScalar + 1;
        end
    end
end

function obj = setOrigInputTypes(obj)
    nNumeric = numel(obj.uNumeric);
    obj.origTypes = cell(1,nNumeric);
    for iIn = 1:nNumeric
        obj.origTypes{iIn} = getInputType(obj.uNumeric{iIn});
    end
end

function obj = rollUpScalarProps(obj,ignoreZero)
    
    for idxScalar = 1:obj.nTot
        input2 = obj.vals(idxScalar);
        if ~input2.valIsFinite
            obj.anyNonFinite = true;
            continue
        else
            obj.anyFinite = true;
        end
        if input2.isZero
            if ignoreZero
                continue
            end
        else
            obj.anyNonZero = true;
        end
        
        bitSpan = input2.WordLength;

        if input2.isNegative
            obj.anyNegative = true;
            obj.maxNegBitSpan = max(obj.maxNegBitSpan,bitSpan);
        else
            obj.maxPosBitSpan = max(obj.maxPosBitSpan,bitSpan);
        end
        
        obj.maxPow2Wt = max( obj.maxPow2Wt, input2.maxPow2Wt);
        if ~isempty(input2.maxPow2WtPositive)
            obj.maxPow2WtPositive = max( obj.maxPow2WtPositive, input2.maxPow2WtPositive);
        end
        if ~isempty(input2.maxPow2WtNegative)
            obj.maxPow2WtNegative = max( obj.maxPow2WtNegative, input2.maxPow2WtNegative);
        end
        obj.minPow2Wt = min( obj.minPow2Wt, input2.FixedExponent);
        obj.max_minPow2Wt = max( obj.max_minPow2Wt, input2.FixedExponent);
    end  
end


function obj = setGroupExtremeProps(obj)
    
    if obj.anyNegative
        if ~isempty(obj.maxPow2WtNegative)
            assert(obj.maxPow2Wt >= obj.maxPow2WtNegative);
        end
        if ~isempty(obj.maxPow2WtPositive)
            assert(obj.maxPow2Wt >= obj.maxPow2WtPositive);
            if obj.maxPow2Wt <= obj.maxPow2WtPositive
                obj.maxPow2Wt = obj.maxPow2Wt + 1;
            end
        end
        obj.maxBitSpan = max(...
            obj.maxPosBitSpan+1,...
            obj.maxNegBitSpan);
    else
        if ~isempty(obj.maxPow2WtPositive)
            assert(obj.maxPow2Wt >= obj.maxPow2WtPositive);
        end
        obj.maxBitSpan = obj.maxPosBitSpan;
    end
end


function obj = setGroupProps(obj)
    
    obj = rollUpScalarProps(obj,true);
    if obj.opt.InType
        obj = updateRangesUsingOrigTypeInfo(obj);
    else
        obj = pickAndApplyWeightingForZeros(obj);
    end
    obj = setGroupExtremeProps(obj);
end

function obj = pickAndApplyWeightingForZeros(obj)
   
    maxPow2WtPositive = -inf;
    minPow2Wt = inf;
    
    if obj.anyNonZero
        % If any original type was not floating point
        % choose a positive weighted bit column for zero
        % that is in the minimum bit span representations
        % and as close as possible to column 2^0
        %
        minPow2Wt = obj.minPow2Wt;
        maxPow2WtPositive = obj.maxPow2Wt;
    else
        % All values are zero, so use the original non-floating-point
        % types to determine power of 2 bit column for zero
        %
        for i = 1:numel(obj.origTypes)
            curType = obj.origTypes{i};
            if isfixed(curType)
                curType = fixed.internal.type.copyTrivialSlopeAdjustBias(curType);
                fzx = fi(0,curType);
                r = numericDispUtil.getBinPtPow2ColInfo(fzx);
                minPow2Wt = min(minPow2Wt,r.minPow2Wt);
                maxPow2WtPositive = max(maxPow2WtPositive,r.maxPow2WtPositive);
            end
        end
    end
    if isfinite( maxPow2WtPositive )        
        pow2ExpForZero = max(min(0,maxPow2WtPositive),minPow2Wt);
    else
        pow2ExpForZero = 0;
    end
    
    % Set all zero values to a common tight representation
    %
    sharedZero = fi(0,0,1,-pow2ExpForZero);    
    for idxScalar = 1:obj.nTot
        input2 = obj.vals(idxScalar);
        if input2.isZero
            obj.vals(idxScalar).minBitSpanBinPt = sharedZero;
            obj.vals(idxScalar).bin = sharedZero.bin;
            obj.vals(idxScalar) = numericDispUtil.getBinPtPow2ColInfo(sharedZero,obj.vals(idxScalar));
        end
    end  
    obj = rollUpScalarProps(obj,false);
end

function obj = updateRangesUsingOrigTypeInfo(obj)
    
    for idxScalar = 1:obj.nTot
        input2 = obj.vals(idxScalar);
        if ~input2.valIsFinite
            continue
        end        
        curVal = input2.valBinPtTypeBasedOnOrigType;
        curValNeg = input2.isNegative; 
        r = numericDispUtil.getBinPtPow2ColInfo(curVal);
        
        if curValNeg
            obj.maxNegBitSpan = max(obj.maxNegBitSpan,r.WordLength);
        else
            obj.maxPosBitSpan = max(obj.maxPosBitSpan,r.WordLength);
        end
        
        obj.maxPow2Wt = max( obj.maxPow2Wt, r.maxPow2Wt);
        if ~isempty(r.maxPow2WtPositive)
            obj.maxPow2WtPositive = max( obj.maxPow2WtPositive, r.maxPow2WtPositive);
        end
        if ~isempty(r.maxPow2WtNegative)
            obj.maxPow2WtNegative = max( obj.maxPow2WtNegative, r.maxPow2WtNegative);
        end
        
        obj.minPow2Wt = min( obj.minPow2Wt, r.FixedExponent);
        obj.max_minPow2Wt = max( obj.max_minPow2Wt, r.FixedExponent);
    end  
    %obj = setGroupExtremeProps(obj);
end
