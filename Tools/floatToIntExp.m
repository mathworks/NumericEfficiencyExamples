function [vInt,vPow2Exp] = floatToIntExp(u)
    %floatToIntExp split floating point value into an integer value and an
    %exponent

    assert(typeFitsInDouble(u),'Type of input must be a subset of double');

    v = double(u);
    
    vInt = v;
    vPow2Exp = zeros(size(v));
    
    ii = isfinite(v) & 0 ~= v;

    if any(ii,'all')
        [vInt(ii),vPow2Exp(ii)]=log2(u(ii));
        eMul = 53;
        vInt(ii) = vInt(ii).*2.^eMul;
        vPow2Exp(ii) = vPow2Exp(ii) - eMul;
        [vInt(ii),vPow2Exp(ii)] = removeTrailZeros(vInt(ii),vPow2Exp(ii));
    end
end

function [vInt,vPow2Exp] = removeTrailZeros(vInt,vPow2Exp)

    assert(all(floor(vInt)==vInt),'Input should be an integer value.')

    au = abs(vInt);    
    assert(all(au<flintmax),'Input should be less than flintmax');
    
    e = 32;
    v = 2^e;
    
    while e > 0
        quot = floor( vInt ./ v );
        ii = (v.*quot) == vInt;
        if any(ii)
            vInt(ii) = quot(ii);
            vPow2Exp(ii) = vPow2Exp(ii)+e;
        else
            e = floor(e/2);
            v = 2^e;
        end
    end
end
