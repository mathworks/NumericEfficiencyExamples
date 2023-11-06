clc

if 0
    n = 4;
    fe = -8;
    v = 2^-8*(0:(2^n-1)).';
    vf = fi(v,0,n,-fe);
else
    dt = 'sfix8_En3';
    %dt = 'half';
    ds1 = fixed.DataSpecification(dt);
    if 0
        dg = fixed.DataGenerator('DataSpecifications', ds1,'NumDataPointsLimit', 50);
    else
        dg = fixed.DataGenerator('DataSpecifications', ds1);
    end
    vf = dg.outputAllData.';
end

showAllDisp('doubles',vf)


% Copyright 2019-2023 The MathWorks, Inc.
