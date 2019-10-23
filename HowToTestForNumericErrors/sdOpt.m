function opt = sdOpt(varargin)
    %sdOpt initialize options for showDifferences
    
    % Copyright 2019 The MathWorks, Inc.
    
    % String to describe first output
    %
    if nargin > 0
        opt.sOut1 = varargin{1};
    else
        opt.sOut1 = '';
    end
    
    % String to describe second output
    %
    if nargin > 1
        opt.sOut2 = varargin{2};
    else
        opt.sOut2 = '';
    end
    
    % Strings to describe inputs
    %
    if nargin > 2
        opt.sIn = varargin(3:end);
    end
end
