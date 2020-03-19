function y = doubleToSymRatRecovery(u)
%doubleToSymRatRecovery get simplest symbolic rational that equals input
%  when cast back to double precision
%
% The function seeks to recover the simple value that a user intended
% when entering a double value.
%
% For example if the user entered the MATLAB code
%   u = 0.05
% or
%   u = 1/20
% the value created will be quantized to the nearest representable
% double value which is
%   castToSymLossless(u) 
%     3602879701896397/72057594037927936
%
% Assuming the user entered a simple rational, this function would 
% recover it.
%   doubleToSymRatRecovery(u)
%      1/20
%
% In ideal math, the two values are not equal
%   castToSymLossless(u) - doubleToSymRatRecovery(u)
%      1/360287970189639680
%
% But in double the value are equal
%  double(castToSymLossless(u)) == double(doubleToSymRatRecovery(u))
%    1
% see also rat, castToSymLossless

%   Copyright 2019 The MathWorks, Inc.

    assert(numel(u) == 1);
    assert(typeFitsInDouble(u),'Type of input must be a subset of double');

    v = double(u);

    [n,d] = rat(v,0);
    
    if u == (n/d)
        y = sym(n) / sym(d);
    else
        y = castToSymLossless(v);
    end
end
