function y = floatToFiMantissaEncoding(u,attribOrNameValOrTotalBits, expBits)


    % Copyright 2019-2023 The MathWorks, Inc.

    if isstruct(attribOrNameValOrTotalBits)
        attrib = attribOrNameValOrTotalBits;
    elseif nargin < 3
        attrib = fixed.internal.type.attribFloatingPoint(attribOrNameValOrTotalBits);
    else
        attrib = fixed.internal.type.attribFloatingPoint(attribOrNameValOrTotalBits, expBits);
    end

    assert(isscalar(u))
    assert(all(isfinite(u)))
    assert(isreal(u))

    wl = attrib.mantissaBitsEffective+1;
    if abs(u) >= attrib.realmin
        y = fi(u,1,wl);
    else
        fl = -attrib.log2Tiny;
        y = fi(u,1,wl,fl);
    end
end
