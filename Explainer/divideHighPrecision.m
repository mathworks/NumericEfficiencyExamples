function y = divideHighPrecision(a,b)
    % divideHighPrecision for fi objects with binary-point scaling
    % 


    % Copyright 2019-2023 The MathWorks, Inc.

    assert(a.isscalingbinarypoint && b.isscalingbinarypoint, "Only binary-point fixed-point cases are supported.")

    integerDivFixedExponent = a.FixedExponent - b.FixedExponent;

    rangeFE = integerDivFixedExponent + a.WordLength - 1;
    isSigned = a.SignednessBool || b.SignednessBool;

    if a.SignednessBool && b.SignednessBool
        % Make from for -128/-1 = +128
        rangeFE = rangeFE + 1;
    elseif ~a.SignednessBool && b.SignednessBool
        % Make from for 127/-1 = -127
        
        rangeFE = rangeFE + 1;
    end

    wl = rangeFE - integerDivFixedExponent + 1;

    % if wl < (64-16)
    %     extraPrecisionBits = 64 - wl;
    % else
    %     extraPrecisionBits = 16;
    % end

    maxAbsSI = 2.^(b.WordLength - b.SignednessBool);

    % minDist = 1/(maxAbsSI-1)  - 1/maxAbsSI 
    %
    %            maxAbsSI - (maxAbsSI-1)
    %         = ----------------------------
    %            (maxAbsSI-1) * maxAbsSI
    %
    %                        1
    %         = ----------------------------
    %            (maxAbsSI-1) * maxAbsSI

    log2MinDist = floor( -log2(maxAbsSI-1) - log2(maxAbsSI) );
   
    extraPrecisionBits = 8 + 1 - log2MinDist;

    wl2 = wl + extraPrecisionBits;
       
    nty = numerictype(...
        isSigned,...
        wl2, ...
        -(integerDivFixedExponent - extraPrecisionBits));

    y = nty.divide(a,b);
end
