function y = castAllToType(numType,uNumeric)
    %castAllToType cast cell of numeric inputs to a vector of specified type
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    nTot = numericDispUtil.getNumRealScalars(uNumeric{:});

    y = fi(zeros(nTot,1),numType);
    idxScalar = 1;
    nNumeric = numel(uNumeric);
    for iIn = 1:nNumeric
        u = uNumeric{iIn};
        validateattributes(u, {'numeric','embedded.fi','logical'},...
            {'real'},'numericDispUtil.castAllToType','uNumeric',2);
        n = numel(u);
        for j=1:n
            curU = u(j);
            if isfinite(curU)
                y(idxScalar) = curU;
            end
            idxScalar = idxScalar + 1;
        end
    end
end
