function headline(sTitle)
    % Print a banner headline to command window, 1980s style.
    
    % Copyright 2019 The MathWorks, Inc.
    
    nWide = 70;
    fprintf('%s\n',repmat('-',nWide));
    fprintf('%s\n',sTitle);
    fprintf('%s\n',repmat('-',nWide));
end
