function y = flattenAndInterLeave(u)
    % flattenAndInterLeave flatten numeric input and if complex interleave
    % real and imaginary parts
        
    % Copyright 2019 The MathWorks, Inc.

    % flatten the input
    uFlat = u(:);
    
    if isreal(uFlat)
        y = uFlat;
    else
        % interlace real and imag
        nFlat = numel(uFlat);
        uClumpedRealThemImag = [real(uFlat); imag(uFlat)];
        nClumped = numel(uClumpedRealThemImag);
        
        indexForRearrange = 1:nClumped;
        
        % Map odd indices of output to first half of clumped
        indexForRearrange(1:2:(nClumped-1)) = 1:nFlat; 
        
        % Map even indices of output to second half of clumped
        indexForRearrange(2:2:nClumped) = nFlat + (1:nFlat);
        
        y = uClumpedRealThemImag(indexForRearrange);
    end
end
