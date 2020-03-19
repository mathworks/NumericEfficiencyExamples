function dispBinPedanticExtend(varargin)
    %dispBinPt display binary values in labeled bit weight columns
    %   Columns will be based on union of original non-float types
    %   and minimum bit spans of floating point types.
    %   If two's complement is used, positive values will always be
    %   shown with a leading zero. If needed, an extra range end column
    %   will be added to achieve that.
    %   All values will show all bits.
    %   Display will sign extend the range bits 
    %   Display will extend the precision bits with zeros
    %
    % Example
    % dispBinPedanticExtend(3.125,-0.25,4,uint8(97))
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %                                            Weighted Bit Columns
    %                -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----
    %  Real World     2^7    2^6    2^5    2^4    2^3    2^2    2^1    2^0    2^-1   2^-2   2^-3
    %     Value       128     64     32     16     8      4      2      1     0.5    0.25  0.125
    %                -----  -----  -----  -----  -----  -----  -----  -----  -----  -----  -----
    %     3.125   =    0      0      0      0      0      0      1      1      0      0      1
    %     -0.25   =    1      1      1      1      1      1      1      1      1      1      0
    %       4     =    0      0      0      0      0      1      0      0      0      0      0
    %      97     =    0      1      1      0      0      0      0      1      0      0      0

    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','Pedantic','extendRange',true,'extendPrecision',true),varargin{:});
end
