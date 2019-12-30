function dispBinPedanticInType(varargin)
    %dispBinPt display binary values in labeled bit weight columns
    %   columns will be based on union of original non-float types
    %   and minimum bit spans
    %
    % Example
    %   dispBinPedanticInType(uint(24,96))
    %
    % All values non-negative: Unsigned Encoding shown
    %             Bit Column Weights
    %  ---  ---  ---  ---  ---  ---  ---  ---
    %  2^7  2^6  2^5  2^4  2^3  2^2  2^1  2^0     Real World Value
    %  128   64   32   16   8    4    2    1
    %  ---  ---  ---  ---  ---  ---  ---  ---
    %   0    0    0    1    1    0    0    0    =  24
    %   0    1    1    0    0    0    0    0    =  96

    % Copyright 2019 The MathWorks, Inc.

    dispVarious(struct('preferFormat','Pedantic','InType',true),varargin{:});
end
