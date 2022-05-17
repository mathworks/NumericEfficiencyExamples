function dispFloatInType(varargin)
    %dispFloatInType display floating point values
    %
    % Example:
    % dispFloatInType(realmin('single'))
    %
      
    % Copyright 2019-2021 The MathWorks, Inc.

    dispVarious(struct('preferFormat','FloatingPoint','InType',true),varargin{:});
end
