function y = plusWrap(a,b)
    %plusWrap add two inputs with overflows wrapping modulo 2^n
    %
    % The inputs must be the same integer or fixed-point type
    % The output will have the same type as the inputs

    % Copyright 2019 The MathWorks, Inc.

    a2 = prepCheckInputs(a);
    b2 = prepCheckInputs(b);    
    checkPair(a2,b2);
    y2 = a2 + b2;
    checkPair(a2,y2);
    y2 = removefimath(y2);
    y = cast(y2,'like',a);
end

function a = prepCheckInputs(a)
    
    if isinteger(a)
        a = fi(a);
    end
        
    isFiBinPt = isfi(a) && isfixed(a) && isscalingbinarypoint(a);
    
    assert(isFiBinPt);
    
    wl = a.WordLength;
    
    fm = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap', ...
        'ProductMode', 'KeepLSB', ...
        'ProductWordLength', wl, ...
        'SumMode', 'KeepLSB', ...
        'SumWordLength', wl, ...
        'CastBeforeSum', true);
    
    a = setfimath(a,fm);    
end

function checkPair(a,b)
    
    nta = numerictype(a);
    ntb = numerictype(b);
    
    assert(nta.isequivalent(ntb));
end
