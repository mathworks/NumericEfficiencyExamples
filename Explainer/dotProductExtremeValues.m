function r = dotProductExtremeValues(inputs, weights, lenDotProd, offset)
    %dotProductExtremeValues determine extreme values and full-precision
    %accumulator data type for dot product.
    %
    % Usage
    %   r = dotProductExtremeValues(inputs, weights, lenDotProd, offset)
    % Input arguments
    %   inputs  provides data type of input
    %   weights provides data type of weights
    %           optionally can provide known constant values of weights
    %   lenDotProd length of the dot product
    %           if weights is vector, lenDotProd is optional,
    %              if giveen must agree with lenght of weights
    %   offset  optional value added to dot product result
    % Output
    %   r  structure containing 
    %      First, analysis of worst case ranges and accumulator type
    %        assuming inputs and weights can have any representable value
    %      Second analysis If weights is given as numeric vector
    %        weights and optional offset are treated as constant values
    %        assume inputs can have any representable value
    %        under these assumptions
    %        worst case ranges and accumulator type


    % Copyright 2019-2023 The MathWorks, Inc.

    if nargin < 4
        offset = [];
    end
    if isempty(offset)
        ntOffset = [];
    else
        ntOffset = fixed.extractNumericType(offset);
    end

    ntu = fixed.extractNumericType(inputs);
    ntw = fixed.extractNumericType(weights);

    if isnumeric(weights)
        lenWeights = numel(weights);
    else
        lenWeights = [];        
    end

    if nargin < 3 || isempty(lenDotProd)
        lenDotProd = lenWeights;
    end
    assert( lenDotProd >= 1);

    weightsKnown = ~isempty(lenWeights) && lenWeights == lenDotProd;
    r.weightsKnown = weightsKnown;

    assert( ~isempty(lenDotProd) );

    assert( isempty(lenWeights) || lenWeights == 1 || lenWeights == lenDotProd);

    assert( isempty(offset) || ~isnumeric(offset) || numel(offset) == 1);

    rInput = range(ntu);
    rWeights = range(ntw);

    if isempty(ntOffset)
        rOffset = [];
    else
        rOffset = range(ntOffset);
    end

    r.typeOnly = getExtremes(rInput,rWeights,lenDotProd,rOffset);
    
    if weightsKnown
        if ~isempty(rOffset) && isnumeric(offset)

            rOffset2 = offset;
        else
            rOffset2 = rOffset;
        end

        r.constWeights = getExtremesConstWeights(rInput,weights,rOffset2);
    end
end

function r = getExtremes(rInput,rWeights,lenDotProd,rOffset)

    extremeProd = [
       rInput(1) .* rWeights(1)
       rInput(1) .* rWeights(2)
       rInput(2) .* rWeights(1)
       rInput(2) .* rWeights(2)    
    ];

    hi = max(extremeProd);
    lo = min(extremeProd);

    nwl = ceil(log2(lenDotProd)+1);

    n = fi(lenDotProd,0,nwl,0);
    
    yHi = n .* hi;
    yLo = n .* lo;

    if ~isempty(rOffset)
        yHi = yHi + max(rOffset);
        yLo = yLo + min(rOffset);
    end

    r = setAccum(yLo,yHi);    
end


function r = getExtremesConstWeights(rInput,weights,rOffset)

    if isempty(rOffset)
        isFirst = true;
    else
        isFirst = false;
        yHi = max(rOffset);
        yLo = min(rOffset);
        accumHi = yHi;
        accumLo = yLo;
    end

    for i=1:numel(weights)
        curWeight = weights(i);
           
        curProd = rInput .* curWeight;

        curProdMax = max(curProd);
        curProdMin = min(curProd);        

        if isFirst
            yHi = curProdMax;
            yLo = curProdMin;
            accumHi = curProdMax;
            accumLo = curProdMin;
            isFirst = false;

            %i, curProdMin, curProdMax, accumLo, accumHi, yLo, yHi
            continue
        end

        yHi = yHi + curProdMax;
        yLo = yLo + curProdMin;

        if accumHi < curProdMax
            accumHi = curProdMax;
        end
        if accumHi < yHi
            accumHi = yHi;
        end
        if accumLo > curProdMin
            accumLo = curProdMin;
        end
        if accumLo > yLo
            accumLo = yLo;
        end

        %i, curProdMin, curProdMax, accumLo, accumHi, yLo, yHi
    end

    dummy = yLo + yHi + accumLo + accumHi;
    ntDummy = numerictype(dummy);

    yHi = fi(yHi,ntDummy);
    yLo = fi(yLo,ntDummy);
    accumLo = fi(accumLo,ntDummy);
    accumHi = fi(accumHi,ntDummy);

    r = setAccum(yLo,yHi,accumLo,accumHi);
end

function r = setAccum(yLo,yHi,accumLo,accumHi)

    siOne = fi([],numerictype(yLo),'bin','1');

    yType = fixed.internal.type.tightFixedPointType([siOne,yLo,yHi]);

    yHi = fi(yHi,yType);
    yLo = fi(yLo,yType);

    r.yMax = yHi;
    r.yMin = yLo;
    r.yTypeFullPrecision = yType;

    if nargin >= 3
        r2 = setAccum(accumLo,accumHi);
    else
        r2 = r;
    end
    r.accumMax = r2.yMax;
    r.accumMin = r2.yMin;
    r.accumTypeFullPrecision = r2.yTypeFullPrecision;
end


