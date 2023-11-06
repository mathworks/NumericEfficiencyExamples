function [yDefault, yHighPrecision] = exFixptDivision(a,b,yDefaultLike,yHighPrecisionLike) %#codegen


    % Copyright 2019-2023 The MathWorks, Inc.

    fm2 = fimath('RoundingMethod', 'Zero', ...
        'OverflowAction', 'Saturate');

    fm3 = fimath('RoundingMethod', 'Zero', ...
        'OverflowAction', 'Wrap');
    
    a2 = setfimath(a,fm2);
    b2 = setfimath(b,fm2);

    a3 = setfimath(a,fm3);
    b3 = setfimath(b,fm3);

    nt1 = fixed.extractNumericType(yDefaultLike);
    yDefault2 = divide(nt1,a2,b2);   
    yDefault = removefimath(yDefault2);

    nt2 = fixed.extractNumericType(yHighPrecisionLike);
    yHighPrecision2 = divide(nt2,a3,b3);   
    yHighPrecision = removefimath(yHighPrecision2);
end