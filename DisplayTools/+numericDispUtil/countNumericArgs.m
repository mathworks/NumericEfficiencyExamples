function nNumeric = countNumericArgs(varargin)
    % count number of numeric inputs for presizing other variables.
    %
    nNumeric = 0;
    
    for iIn = 1:nargin
        u = varargin{iIn};
        if numericDispUtil.isNumericOrlogical(u)
            nNumeric = nNumeric + 1;
        end
    end
end
