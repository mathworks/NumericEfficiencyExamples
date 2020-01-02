function y = castAllToType(numType,uNumeric,nTot)
    %castAllToType cast all inputs to specified type
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    y = fi(zeros(nTot,1),numType);
    idxScalar = 1;
    nNumeric = numel(uNumeric);
    for iIn = 1:nNumeric
        u = uNumeric{iIn};
        n = numel(u);
        for j=1:n
            curU = u(j);
            if isfinite(curU)
                y(idxScalar) = curU;
            else
                y(idxScalar) = 0;
            end
            idxScalar = idxScalar + 1;
        end
    end
end
