function dispBinIntMantExpInType(varargin)
    %dispBinIntMantExpAlign using base2 exponent and 
    % binary integer mantissa. Mantissa will use type of original value,
    % except for two's complement an extra bit will be added if needed,
    % so that positive values will always have a leading zero.
    %
    % Example:
    % dispBinIntMantExpAlignInType(half([1041.*2.^(-34:8:05),65504,-65504]))
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %        Real World         Notation: Integer Mantissa
    %           Value                 and Pow2 Exponent
    %  5.9604644775390625e-08 =                              000000000001 * 2^-24
    %  1.5497207641601562e-05 =                              000100000100 * 2^-24
    %   0.003971099853515625  =                        010000010001       * 2^-18
    %       1.0166015625      =                010000010001               * 2^-10
    %          260.25         =        010000010001                       * 2^-2
    %           65504         = 011111111111                              * 2^5
    %          -65504         = 100000000001                              * 2^5
      
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','IntMantExp','InType',true),varargin{:});
end
