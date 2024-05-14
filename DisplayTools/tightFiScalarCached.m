function y = tightFiScalarCached(u)
    % determine minium bit span for scalar value
    %

    % Copyright 2019-2023 The MathWorks, Inc.

    % determine minium bit span for scalar value
    %
    validateattributes(u, {'numeric','embedded.fi','logical'},...
        {'real','finite','scalar'});
    u = fixed.internal.math.castLogicalToUfix1(u);
    y = fixed.internal.type.tightFi(u);    
end
