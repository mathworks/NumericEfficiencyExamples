% Regression Test using MATLAB Unit Test Framework
% Comparing (A+B)-B to B
%
classdef testClassNotJustA < matlab.unittest.TestCase
    methods (Test)
        function testNotJustAFull(testCase)
            % Step 1: Specification Data Attributes
            ds1 = fixed.DataSpecification('double');
            % Step 2: Cosntruct Data Generator
            dg = fixed.DataGenerator('DataSpecifications',{ds1,ds1});
            % Step 3 - Option 1: Output all cominbations together
            [vA, vB] = dg.outputAllData;
            % Step 4 - Gather results
            yOrig = vA + vB - vB;
            yAlt  = vA;
            %% Step 5 - Compare
            verifyEqual(testCase,yAlt,yOrig)
        end
    end
end

% Copyright 2019 The MathWorks, Inc.
