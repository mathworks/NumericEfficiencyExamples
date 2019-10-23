% Compare 0*A vs. 0 to see if they give the exact same
% result using floating point computer mathematics

clc
% Step 1: Specify Input Attributes
ds1 = fixed.DataSpecification('single');

% Step 2: Construct Data Generator and
%         Output numerically rich test values
dg = fixed.DataGenerator('DataSpecifications',{ds1});
vA = dg.outputAllData;

% Step 3 - Collect golden baseline and
%          output of algorithm under test
zeroScalarA = zeros(1,1,'like',vA);
yOrig = zeroScalarA * vA;
yAlt  = zeros(size(vA),'like',vA);

% Step 4 - Compare
opt = sdOpt('0*A','0','A');
showDifferences(yOrig, yAlt, opt, vA);

% Copyright 2019 The MathWorks, Inc.
