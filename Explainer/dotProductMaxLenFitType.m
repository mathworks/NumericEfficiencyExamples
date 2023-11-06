function lenMaxNoChanceOverflow = dotProductMaxLenFitType(ydt, inputs, weights, offset)
    %dotProductMaxLenFitType determine max length of dot product that will
    % NOT overflow specified accumulator container type.


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

    nty = fixed.internal.type.stripScaling( fixed.extractNumericType(ydt) );

    prodWL = ntu.WordLength + ntw.WordLength - (ntu.WordLength==1 || ntw.WordLength==1);

    hiWL = max(3, nty.WordLength + 3 - prodWL); 

    lenHi = 2^hiWL;
    lenLo = 0;

    while (lenHi - lenLo) > 1
        lenMid = floor(0.5*(lenHi + lenLo));
        r = dotProductExtremeValues(ntu, ntw, lenMid, ntOffset);

        accumContainter = fixed.internal.type.stripScaling( r.typeOnly.accumTypeFullPrecision );

        isSuper = fixed.internal.type.isTypeSuperset(nty, accumContainter);

        if isSuper
            lenLo = lenMid;
        else
            lenHi = lenMid;
        end
    end

    lenMaxNoChanceOverflow = lenLo;

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
end
