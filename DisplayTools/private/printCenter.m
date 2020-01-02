function printCenter(str,lenTotal)
    %printCenter fprintf string centered
    
    % Copyright 2019-2020 The MathWorks, Inc.

    lenStr = length(str);
   
    nSpace = lenTotal - lenStr;
    
    nAfter = floor(nSpace/2);
    bBefore = nSpace - nAfter;
    fprintf('%s%s%s',...
        repmat(' ',1,bBefore),...
        str, ...
        repmat(' ',1,nAfter));
end