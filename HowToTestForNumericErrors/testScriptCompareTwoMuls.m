% Compare two multiplication algorithms to determine if they 
% give the exact same results

clc
%% Step 1: Specification Data Attributes
ds1 = fixed.DataSpecification('int32');
%% Step 2: Cosntruct Data Generator
dg = fixed.DataGenerator('DataSpecifications',{ds1,ds1});
%% Step 3 - Option 1: Output all cominbations together
[vA, vB] = dg.outputAllData;
%% Step 4 - Gather results
yOrig = mulSR16( vA, vB );
yAlt  = mulSR16_alt( vA, vB );
%% Step 5 - Compare
showDifferences(yOrig, yAlt, sdOpt('','','A','B'), vA, vB );


%% 
function y = mulSR16(vA,vB)
    a2 = fi(vA,1,32,0);
    b2 = fi(vB,1,32,0);
    fullProd = a2 .* b2;
    sr = 16;
    y = fi( fullProd, 1, 32, -sr, fimathLean() );
    %y = stripscaling(y);
end

%%
function y = mulSR16_alt(vA,vB)
    a2 = double(vA);
    b2 = double(vB);
    doubleProd = a2 .* b2;
    sr = 16;
    y = fi( doubleProd, 1, 32, -sr, fimathLean() );
    %y = stripscaling(y);
end


function fm = fimathLean()
    fm = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap', ...
        'ProductMode', 'FullPrecision', ...
        'SumMode', 'FullPrecision');
end

% Copyright 2019 The MathWorks, Inc.
