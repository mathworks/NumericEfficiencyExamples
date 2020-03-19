function [opts,uNumeric] = splitOptionsFromNumerics(varargin)
    %splitOptionsFromNumerics split function inputs: numeric vs options
    %
    % An input is treated as an option if it is a struct, or
    % a scalar char or string.
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    opts = struct();
    nNumeric = numericDispUtil.countNumericArgs(varargin{:});
    
    uNumeric = cell(1,nNumeric);
    iNumeric = 1;
    
    for iIn = 1:nargin
        u = varargin{iIn};
        validateattributes(u, {'numeric','embedded.fi','logical','char','string','struct'},...
            {'real'},'numericDispUtil.splitOptionsFromNumerics','input',iIn);
        if numericDispUtil.isNumericOrlogical(u)
            u = numericDispUtil.flattenAndInterLeave(varargin{iIn});
            u = fixed.internal.math.castLogicalToUfix1(u);
            uNumeric{iNumeric} = u;
            iNumeric = iNumeric + 1;
        elseif fixed.internal.type.isAnyScalarString(u)
            opts.(u) = true;
        else
            assert(isstruct(u))
            fns = fieldnames(u);
            for iFn = 1:numel(fns)
                fn = fns{iFn};
                opts.(fn) = u.(fn);
            end
        end
    end
end
