function dispBinIntMantExp(varargin)
    %dispBinIntMantExp using binary integer mantissa and base2 exponent
    %
    % Example:
    % dispBinIntMantExp(3.125,-0.25,4)
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %  Real World   Notation: Integer Mantissa
    %     Value           and Pow2 Exponent
    %     3.125   = 011001 * 2^-3
    %     -0.25   =     10 * 2^-3
    %       4     =     01 * 2^2
      
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','IntMantExp'),varargin{:})
end
