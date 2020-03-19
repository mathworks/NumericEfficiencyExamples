function dispBinPedanticInType(varargin)
    %dispBinPt display binary values in labeled bit weight columns
    %   columns will be based on original types of values supplied.
    %   Values will show spaces, instead of 0 or 1, for columns
    %   that are not part of the original type with one exception.
    %   If two's complement is used, then positive values will always
    %   be shown with a leading 0. To achieve that, if necessary, an 
    %   extra 0 one place to the left of those in the type will be shown.
    %
    % Example 1:
    %   dispBinPedanticInType(uint8([24,96]),fi(13,0,5,0),true)
    %
    % All values non-negative: Unsigned Encoding shown
    %
    %                         Weighted Bit Columns
    %                ---  ---  ---  ---  ---  ---  ---  ---
    %  Real World    2^7  2^6  2^5  2^4  2^3  2^2  2^1  2^0
    %     Value      128   64   32   16   8    4    2    1
    %                ---  ---  ---  ---  ---  ---  ---  ---
    %      24     =   0    0    0    1    1    0    0    0
    %      96     =   0    1    1    0    0    0    0    0
    %      13     =                  0    1    1    0    1
    %       1     =                                      1
    %
    % Example 2:    
    % dispBinPedanticInType(uint8(17),half(17))
    %
    % All values non-negative: Unsigned Encoding shown
    %
    %                                             Weighted Bit Columns
    %                -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------
    %  Real World      2^7      2^6      2^5      2^4      2^3      2^2      2^1      2^0      2^-1     2^-2     2^-3     2^-4     2^-5     2^-6
    %     Value        128       64       32       16       8        4        2        1       0.5      0.25    0.125    0.0625  0.03125
    %                -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------
    %      17     =     0        0        0        1        0        0        0        1
    %      17     =                       0        1        0        0        0        1        0        0        0        0        0        0
    %
    % Example 3:    
    %     dispBinPedanticInType(...
    %        fi(1,0,2,2),...
    %        fi(1,0,4,4),...
    %        fi(1,0,6,6),...
    %        fi(1,0,8,8),...
    %        fi(1,0,10,10))
    %
    % All values non-negative: Unsigned Encoding shown
    %
    %                                               Weighted Bit Columns
    %                  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------
    %   Real World       2^-1     2^-2     2^-3     2^-4     2^-5     2^-6     2^-7     2^-8     2^-9    2^-10
    %      Value         0.5      0.25    0.125    0.0625  0.03125
    %                  -------  -------  -------  -------  -------  -------  -------  -------  -------  -------
    %      0.75     =     1        1
    %     0.9375    =     1        1        1        1
    %    0.984375   =     1        1        1        1        1        1
    %   0.99609375  =     1        1        1        1        1        1        1        1
    %  0.9990234375 =     1        1        1        1        1        1        1        1        1        1
    %
    % Example 4: extra bit necessaryon positive value
    %
    % dispBinPedanticInType(uint8(128),int8(-63))
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %                            Weighted Bit Columns
    %                ---  ---  ---  ---  ---  ---  ---  ---  ---
    %  Real World    2^8  2^7  2^6  2^5  2^4  2^3  2^2  2^1  2^0
    %     Value      256  128   64   32   16   8    4    2    1
    %                ---  ---  ---  ---  ---  ---  ---  ---  ---
    %      128    =   0    1    0    0    0    0    0    0    0
    %      -63    =        1    1    0    0    0    0    0    1
    %
    
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','Pedantic','InType',true),varargin{:});
end
