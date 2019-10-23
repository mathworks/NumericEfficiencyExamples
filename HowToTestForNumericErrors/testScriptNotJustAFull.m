% Compare (A+B)-B to B to see if they give the exact same
% result using digital computer mathematics

clc
% Step 1: Specify Input Attributes
ds1 = fixed.DataSpecification('double');

% Step 2: Construct Data Generator and
%         Output numerically rich test values
dg = fixed.DataGenerator('DataSpecifications',{ds1,ds1});
[vA, vB] = dg.outputAllData;

% Step 3 - Collect golden baseline and
%          output of algorithm under test
yOrig = vA + vB - vB;
yAlt  = vA;

% Step 4 - Compare
opt = sdOpt('(A+B)-B',' A','A','B');
showDifferences(yOrig, yAlt, opt, vA, vB );

% Copyright 2019 The MathWorks, Inc.
