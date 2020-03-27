function dispBinPtExtend(varargin)
    %dispBinPtExtend binary point display of input values
    %   Columns will be based on union of original non-float types
    %   and minimum bit spans of floating point types.
    %   If two's complement is used, positive values will always be
    %   shown with a leading zero. If needed, an extra range end column
    %   will be added to achieve that.
    %   All values will show all bits.
    %   Display will sign extend the range bits 
    %   Display will extend the precision bits with zeros
    %
    % Example:
    % dispBinPtExtend(3.125,-0.25,4)
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %  Real World   Notation: Binary Point
    %     Value
    %     3.125   = 0011.001
    %     -0.25   = 1111.110
    %       4     = 0100.000
    
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','BinPt','extendRange',true,'extendPrecision',true),varargin{:});
end
