% For the operation of cast to nearest, compare an algorithm with
% with attractive efficiency properties against a 
% know correct implementation of cast to nearest
clc
% Step 1: Specify Input Attributes
u1Type = numerictype(0,32,4);
ds1 = fixed.DataSpecification(u1Type);
% Step 2: Construct Data Generator and
%         Output numerically rich test values
dg = fixed.DataGenerator('DataSpecifications',{ds1});
valU1 = dg.outputAllData;
% Step 3 - Collect golden baseline and
%          output of algorithm under test
yExpect = castKnownCorrect(valU1);
yActual = castAdd8ShiftRight4(valU1);
% Step 4 - Compare
showDifferences(yExpect, yActual, sdOpt('','','u'), valU1 );








% Known correct implementation of cast to nearest
%
function y = castKnownCorrect(u)
    nty = numerictype(0,32,0);
    fm = fimath('OverflowAction', 'Wrap');
    y = fi(u,nty,fm);
    y = removefimath(y);
end

% algorithm proposed for cast to nearest
% with attractive efficiency properties
%
function y = castAdd8ShiftRight4(u)
    ntu = numerictype(u);
    nty = numerictype(0,32,0);
    fm = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap');
    b = fi(u,ntu,fm);
    c = fi(0.5,ntu,fm);
    d = fi(b+c,ntu,fm);
    y = fi(d,nty,fm);
    y = removefimath(y);
end

% Copyright 2019 The MathWorks, Inc.
