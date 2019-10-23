function className = fullPrecisionSumReduceType(u)
%fullPrecisionSumReduceType full precision integer reducing sum type
%
% Example
% Consider a reducing sum on a uint8 2 by 8 matrix
% the largest possible output is 2*8*255 = 4080.
% That's too big for a uint8 data type to represent
% but small enough for a uint16 data type to represent.
% so
%   fullPrecisionSumReduceType(uint8(255*rand(2,8)))
% returns
%   'uint16'

% Copyright 2019 The MathWorks, Inc.

    persistent yCache
    
    if needNew(yCache,u)
        n = numel(u);
        if n > 1
            nGuardBits = ceil(log2(n));
        else
            nGuardBits = 0;
        end
        nt = numerictype(class(u));
        nBits = nt.WordLength + nGuardBits;
        wlv = [64,32,16,8];
        i = find( nBits <= wlv, 1, 'last');
        className = sprintf('int%d',wlv(i));
        if ~nt.Signed
            className = ['u',className];
        end
        yCache = setCache(yCache,u,className);
    end
    className = yCache.className;
end

function b = needNew(yCache,u)
    
    b = isempty(yCache) || ...
        ~strcmp(yCache.uClass, class(u)) || ...
        any( yCache.dims ~= size(u) );
end

function yCache = setCache(yCache,u,className)
    
    yCache.uClass = class(u);
    yCache.dims = size(u);
    yCache.className = className;
end

