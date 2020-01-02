function dispBinPt(varargin)
    %dispBinPt binary point display of input values
    %
    % Example:
    % dispBinPt(3.125,-0.25,4)
    %
    % Negative values present: Two's Complement Encoding shown
    %    011.001  =   3.125
    %       .110  =  -0.25
    %   0100.     =   4
  
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','BinPt'),varargin{:});
end
