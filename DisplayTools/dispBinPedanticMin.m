function dispBinPedanticMin(varargin)
    %dispBinPt display binary values in labeled bit weight columns
    %   columns will be based minimum bit spans unioned across all values
    %
    % Example
    %   dispBinPedanticMin(5.125,-3.5)
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %                              Weighted Bit Columns
    %                -----  -----  -----  -----  -----  -----  -----
    %  Real World     -2^3   2^2    2^1    2^0    2^-1   2^-2   2^-3
    %     Value        -8     4      2      1     0.5    0.25  0.125
    %                -----  -----  -----  -----  -----  -----  -----
    %     5.125   =    0      1      0      1      0      0      1
    %     -3.5    =           1      0      0      1
    
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','Pedantic'),varargin{:});
end
