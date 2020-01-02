function dispBinIntMantExp(varargin)
    %dispBinIntMantExp using binary integer mantissa and base2 exponent
    %
    % Example:
    % dispBinIntMantExp(3.125,-0.25,4)
    %
    % Negative values present: Two's Complement Encoding shown
    %   011001 * 2^-3  =   3.125
    %       10 * 2^-3  =  -0.25
    %       01 * 2^2   =   4
      
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(struct('preferFormat','IntMantExp'),varargin{:})
end
