function y = fullPrecisionBinaryPointSubtract(a,b)
    % fullPrecisionBinaryPointSubtract
    %
    % For fi objects with binary-point scaling
    % Subtraction operator (-) is full-precision
    % EXCEPT when both inputs are unsigned
    % This function make the exception full-precision too.
    % 

    assert(a.isscalingbinarypoint && b.isscalingbinarypoint, "Only binary-point fixed-point cases are supported.")

    if a.SignednessBool || b.SignednessBool
        y = a - b;
    else
        nta2 = fixed.internal.type.sproutSignBit(a);
        a2 = fi(a,nta2);
        y = a2 - b;
    end
end
