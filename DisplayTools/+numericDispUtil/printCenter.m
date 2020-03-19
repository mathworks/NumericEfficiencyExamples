function s = printCenter(str,lenTotal,doPrint)
    %printCenter fprintf string centered
    
    % Copyright 2019-2020 The MathWorks, Inc.

    doPrint = ~exist('doPrint','var') || doPrint;
    
    lenStr = length(str);
   
    nSpace = lenTotal - lenStr;
    
    nAfter = floor(nSpace/2);
    bBefore = nSpace - nAfter;
    s = sprintf('%s%s%s',...
        repmat(' ',1,bBefore),...
        str, ...
        repmat(' ',1,nAfter));
    if doPrint
        fprintf(s)
    end
end
