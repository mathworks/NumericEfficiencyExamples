function dispBinIntMantExpAlign(varargin)
    %dispBinIntMantExpAlign using base2 exponent and horizontally aligned binary integer mantissa 
    %
    % Example:
    % dispBinIntMantExpAlign(0.125,0.25,0.5,1,2,3.125)
    %
    % All values non-negative: Unsigned Encoding shown
    %
    %  Real World   Notation: Integer Mantissa
    %     Value           and Pow2 Exponent
    %     0.125   =     1 * 2^-3
    %     0.25    =    1  * 2^-2
    %      0.5    =   1   * 2^-1
    %       1     =  1    * 2^0
    %       2     = 1     * 2^1
    %     3.125   = 11001 * 2^-3
      
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','IntMantExpAlign'),varargin{:})
end
