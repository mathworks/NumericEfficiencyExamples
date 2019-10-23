% Compare (A+B)-B to B to see if they give the exact same
% result using digital computer mathematics
% when the inputs are restricted to modest values
% far from the possibility of overflowing to infinity.

clc
% Step 1: Specify Input Attributes
uRange = fixed.Interval(-10,10);
ds1 = fixed.DataSpecification('single','Interval',uRange);

% Step 2: Construct Data Generator and
%         Output numerically rich test values
dg = fixed.DataGenerator('DataSpecifications',{ds1,ds1});
[vA, vB] = dg.outputAllData;

% Step 3 - Collect golden baseline and
%          output of algorithm under test
yOrig = vA + vB - vB;
yAlt  = vA;

% Step 5 - Compare
opt = sdOpt('(A+B)-B',' A','A','B');
showDifferences(yOrig, yAlt, opt, vA, vB );

% Copyright 2019 The MathWorks, Inc.
