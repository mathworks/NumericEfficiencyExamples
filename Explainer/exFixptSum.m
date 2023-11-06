function y = exFixptSum(a,b,yLike) %#codegen


    % Copyright 2019-2023 The MathWorks, Inc.

    fm = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap', ...
        'ProductMode', 'FullPrecision', ...
        'SumMode', 'SpecifyPrecision', ...
        'SumWordLength', yLike.WordLength, ...
        'SumFractionLength', yLike.FractionLength, ...
        'CastBeforeSum', true);
    a2 = setfimath(a,fm);
    b2 = setfimath(b,fm);
    y2 = a2 + b2;
    y = removefimath(y2);
end