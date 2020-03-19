function dispBinPt(varargin)
    %dispBinPt binary point display of input values
    %
    % Example:
    % dispBinPt(3.125,-0.25,4)
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %  Real World   Notation: Binary Point
    %     Value
    %     3.125   =  011.001
    %     -0.25   =     .110
    %       4     = 0100.
      
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','BinPt'),varargin{:});
end
