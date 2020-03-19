function dispBinPtPrefer(varargin)
    %dispBinPtPrefer display of input values in binary point format if not
    % too wide, otherwise use int mantissa with exponent format
    %
    % Example 1:
    % dispBinPtPrefer(3.125,-0.25,4)
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %  Real World   Notation: Binary Point
    %     Value
    %     3.125   =  011.001
    %     -0.25   =     .110
    %       4     = 0100.
    %
    % Example 2:
    % dispBinPtPrefer(realmax,-realmin+eps(0))
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %         Real World          Notation: Integer Mantissa
    %            Value                  and Pow2 Exponent
    %   1.7976931348623157e+308 = 011111111111111111111111111111111111111111111111111111 * 2^971
    %  -2.2250738585072009e-308 =  10000000000000000000000000000000000000000000000000001 * 2^-1074
  
    % Copyright 2019-2020 The MathWorks, Inc.

    dispVarious(varargin{:});
end
