function y = timesWrap(a,b)
    %timesWrap multiply two inputs with overflows wrapping modulo 2^n
    %
    % The inputs must have the same signedness and wordlength
    %    but can have different scaling.
    % The output will have the same signedness and wordlength as the inputs
    %    and will scaling that is the product of the two input slopes.
    %
    % Integers have slope 1, so if both inputs are integers, then
    % since 1 * 1 is 1, the output will also have integer scaling.

    % Copyright 2019 The MathWorks, Inc.
    
    a2 = prepCheckInputs(a);
    b2 = prepCheckInputs(b);    
    checkPair(a2,b2);
    y2 = a2 .* b2;
    checkPair(a2,y2);
    if isinteger(a)
        y = cast(y2,'like',a);
    else
        y = removefimath(y2);
    end
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
    
    assert(nta.SignednessBool == ntb.SignednessBool)
    assert(nta.WordLength == ntb.WordLength)
end
