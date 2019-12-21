function scalingIsTrivial = isFiScalingTrivial(u) %#codegen
    %isFiScalingTrivial does fi object have trivial scaling
    
    %   Copyright 2019 The MathWorks, Inc.
    
    coder.inline('always');

    scalingIsTrivial = coder.const(...
        (0 == u.FixedExponent) && ...
        (1 == u.SlopeAdjustmentFactor) && ...
        (0 == u.Bias));
end
