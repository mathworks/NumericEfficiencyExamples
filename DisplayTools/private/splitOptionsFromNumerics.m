function [opts,uNumeric] = splitOptionsFromNumerics(varargin)
    %splitOptionsFromNumerics split function inputs: numeric vs options
    %
    % An input is treated as an option if it is a struct, or
    % a scalar char or string.
    
    % Copyright 2019 The MathWorks, Inc.
    
    opts = struct();
    nNumeric = countNumerics(varargin{:});
    
    uNumeric = cell(1,nNumeric);
    iNumeric = 1;
    
    for iIn = 1:nargin
        u = varargin{iIn};
        if isNumericOrlogical(u)
            u = flattenAndInterLeave(varargin{iIn});
            %u = fixed.internal.math.castLogicalToUfix1(u);
            uNumeric{iNumeric} = u;
            iNumeric = iNumeric + 1;
        else
            if fixed.internal.type.isAnyScalarString(u)
                opts.(u) = true;
            elseif isstruct(u)
                fns = fieldnames(u);
                for iFn = 1:numel(fns)
                    fn = fns{iFn};
                    opts.(fn) = u.(fn);
                end
            else
                error('Unknown input type.')
            end
        end
    end
end

function nNumeric = countNumerics(varargin)
    % count number of numeric inputs for presizing other variables.
    %
    nNumeric = 0;
    
    for iIn = 1:nargin
        u = varargin{iIn};
        if isNumericOrlogical(u)
            nNumeric = nNumeric + 1;
        end
    end
end
