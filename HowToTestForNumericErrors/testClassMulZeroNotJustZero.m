% Regression Test using MATLAB Unit Test Framework
% Comparing 0*A to 0
%
classdef testClassMulZeroNotJustZero < matlab.unittest.TestCase
    methods (Test)
        function testNotJustAFull(testCase)
            % Step 1: Specification Data Attributes
            ds1 = fixed.DataSpecification('single');
            % Step 2: Construct Data Generator and
            %         Output numerically rich test values
            dg = fixed.DataGenerator('DataSpecifications',{ds1});
            vA = dg.outputAllData;
            % Step 3 - Collect golden baseline and
            %          output of algorithm under test
            zeroScalarA = zeros(1,1,'like',vA);
            yExpect = zeroScalarA * vA;
            yActual  = zeros(size(vA),'like',vA);
            % Step 4 - Compare
            verifyEqual(testCase,yActual,yExpect)
        end
    end
end







% Test util orig
function y = compReducingSumGoldenBaseline(vA)
    sz = size(vA);
    nLast = sz(end);
    className = fullPrecisionSumReduceType(vA(:,:,1));
    y = repmat(zeros(1,1,className),nLast,1);
    for i=1:nLast
        u = vA(:,:,i);
        u2 = cast(u,className);
        y(i) = sum(u2,'all');
    end
end


% Test util alternate
function y = compReducingSumsAlternative(vA)
    sz = size(vA);
    nLast = sz(end);
    for i=1:nLast
        u = vA(:,:,i);
        curY = fullPrecisionSumReduce(u);
        if i==1
            y = repmat(curY,nLast,1);
        else
            y(i) = curY;
        end
    end
end

% Copyright 2019 The MathWorks, Inc.
