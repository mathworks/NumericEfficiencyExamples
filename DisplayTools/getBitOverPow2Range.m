function cv = getBitOverPow2Range(u,p2ExpLo,p2ExpHi,extendRangeGiveSpaces,extendPrecisionGiveSpaces)
    %getBitOverPow2Range from numeric scalar get bits over power of 2 range
    % 
    % For inputs that are not true fixed-point or integer types, the input 
    % will first be converted to a lossless minimum bit span
    % representation. For example, double(3.5) would be converted to 
    % fi(3.5,0,3,1).
    %
    % For any locations specified beyond the converted data type of the input,
    % an input option controls what is returned: a space or a bit value.
    % For the choice of returning a bit value,
    % if the location is beyond the precision end, then '0' is given for
    % that bit.
    % if the location is beyond the range end, then '0' is given in those
    % locations for non-negative values, and '1' is given in those
    % locations for negative values.
    %
    % Usage:
    %    cv = getBitOverPow2Range(u,p2ExpLo,p2ExpHi,extendRangeGiveSpaces,extendPrecisionGiveSpaces)
    % Inputs
    %    u     real scalar numeric value
    %    p2ExpLo integer specifying desired least significant bit corresponds
    %          to column with weight 2^p2ExpLo
    %    p2ExpHi integer specifying desired most significant bit corresponds
    %          to column with weight 2^p2ExpHi
    %    extendRangeGiveSpaces specifies handling bits beyond range end of the
    %          (converted) type of u. True gives spaces ' ', otherwise give
    %          give '1' for negative values and '0' for non-negative.
    %    extendPrecisionGiveSpaces specifies handling bits beyond precision 
    %          end of the (converted) type of u. True gives spaces ' ',
    %          otherwise give '0'.
    % Output
    %    cv     a character row vector made up of values '0', '1', or ' '
    %           The first element of cv corresponds to bit column with
    %           weight 2^p2ExpHi.
    %           The last element of cv corresponds to bit column with
    %           weight 2^p2ExpLo.
        
    % Copyright 2019-2020 The MathWorks, Inc.
    
    validateattributes(u, {'numeric','embedded.fi','logical'},...
        {'real','finite','scalar'});
    validateattributes(p2ExpLo, {'numeric','embedded.fi','logical'},...
        {'real','finite','scalar','integer'});
    validateattributes(p2ExpHi, {'numeric','embedded.fi','logical'},...
        {'real','finite','scalar','integer'});
    assert(p2ExpHi >= p2ExpLo);
    
    u = makeFixpt(u);

    typePow2ExpLo = u.FixedExponent;
    typePow2ExpHi = u.WordLength - 1 + typePow2ExpLo;

    nExtendedRange = max(0,p2ExpHi - max(typePow2ExpHi,p2ExpLo-1));
    nExtendedPrecision = max(0,min(typePow2ExpLo,p2ExpHi+1) - p2ExpLo);

    rawBits = u.bin;
    
    if extendRangeGiveSpaces
        cRange = ' ';
    else
        if u.issigned
            cRange = rawBits(1);
        else
            cRange = '0';
        end
    end
    if extendPrecisionGiveSpaces
        cPrecision = ' ';
    else
        cPrecision = '0';
    end
    cvExtendedPrecision = repmat(cPrecision,1,nExtendedPrecision);
    cvExtendedRange = repmat(cRange,1,nExtendedRange);

    p2ExpLo = max(p2ExpLo,typePow2ExpLo);
    p2ExpHi = min(p2ExpHi,typePow2ExpHi);

    idxLeftOfEnd = (p2ExpHi:-1:p2ExpLo)-typePow2ExpLo;
    cvFromType = rawBits(end - idxLeftOfEnd);

    cv = [cvExtendedRange, cvFromType, cvExtendedPrecision];
end

function u = makeFixpt(u)
    % make true fixed-point as needed
    %
    if islogical(u)
        u = fi(u,0,1,0);
    elseif isinteger(u)
        u = fi(u);
    elseif isfloat(u) || (isfi(u) && ~isfixed(u))
        u = fixed.internal.type.tightFi(u);
    end
end
    
    
    
    
    