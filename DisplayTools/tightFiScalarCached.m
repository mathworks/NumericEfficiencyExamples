function y = tightFiScalarCached(u)
    % determine minium bit span for scalar value
    %
    funcHandle = memoize(@innerTightFi);
    funcHandle.CacheSize = 500;    
    y = funcHandle(u);
end

function y = innerTightFi(u)
    % determine minium bit span for scalar value
    %
    validateattributes(u, {'numeric','embedded.fi','logical'},...
        {'real','finite','scalar'});
    u = fixed.internal.math.castLogicalToUfix1(u);
    y = fixed.internal.type.tightFi(u);    
end
