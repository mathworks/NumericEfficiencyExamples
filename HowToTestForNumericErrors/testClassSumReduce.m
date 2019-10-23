% Regression Test of Reducing Sum using MATLAB Unit Test Framework
%
classdef testClassSumReduce < matlab.unittest.TestCase
    methods (Test)
        function testNotJustAFull(testCase)
            % Step 1: Specification Data Attributes
            ds1 = fixed.DataSpecification('uint8','Dimensions',[2,2]);
            % Step 2: Construct Data Generator and
            %         Output numerically rich test values
            dg = fixed.DataGenerator('DataSpecifications',{ds1});
            vA = dg.outputAllData;
            % Step 3 - Collect golden baseline and
            %          output of algorithm under test
            yExpect = compReducingSumGoldenBaseline( vA );
            yActual = compReducingSumsAlternative( vA );
            % Step 4 - Compare
            verifyEqual(testCase,yActual,yExpect)
        end
    end
end







% Test util original known correct algorithm
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


% Test util alternate algorithm being tested
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
