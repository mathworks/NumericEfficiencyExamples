function n = getNumRealScalars(varargin)
    %getNumRealScalars get number or real scalars that make up all inputs
    %
    % A complex value counts as 2 scalars, the real and imaginary parts.
    
    % Copyright 2019 The MathWorks, Inc.
    
    n = 0;
    for iIn = 1:nargin
        uCur = varargin{iIn};
        nCur = numel(uCur);
        if ~isreal(uCur)
            nCur = 2*nCur;
        end
        n = n + nCur;
    end
end