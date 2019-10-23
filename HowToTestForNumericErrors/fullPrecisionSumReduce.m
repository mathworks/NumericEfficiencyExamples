function y = fullPrecisionSumReduce(u)
%fullPrecisionSumReduce full precision reducing sum
    className = fullPrecisionSumReduceType(u);
    y = zeros(1,1,className);
    szu = size(u);
    for i=1:szu(1)
        for j=1:szu(2)
            y = y + cast(u(i,i),className);
        end
    end
end
 
% Copyright 2019 The MathWorks, Inc.
