function y = exFixptAffineSlopeBiasDotProduct(a,b,offset,yLike) %#codegen


    % Copyright 2019-2023 The MathWorks, Inc.

    a2 = removeBias(a,yLike);
    b2 = removeBias(b,yLike);

    ntaYLike = fixed.extractNumericType(yLike);

    y2 = cast(offset,'like',yLike);

    fm = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap', ...
        'ProductMode', 'SpecifyPrecision', ...
        'ProductWordLength', yLike.WordLength, ...
        'ProductFractionLength', 0, ...
        'SumMode', 'SpecifyPrecision', ...
        'SumWordLength', yLike.WordLength, ...
        'SumFractionLength', 0, ...
        'CastBeforeSum', true);

    y3 = setfimath( stripscaling(y2), fm);
    a3 = setfimath( stripscaling(a2), fm);
    b3 = setfimath( stripscaling(b2), fm);

    for i=1:numel(a)
        y3(:) = y3 + (a3(i)*b3(i));
    end
    y4 = removefimath(y3);

    y = reinterpretcast( y4, ntaYLike);
end


function a2 = removeBias(a,yLike)

    nta = fixed.extractNumericType(a);

    if nta.Bias == 0
        a2 = a;
    else
        siBias = nta.Bias/nta.Slope;
        isSigned1 = nta.SignednessBool || siBias < 0;
        siBiasA = fi( siBias, isSigned1, yLike.WordLength, 0 );

        fma = fimath('RoundingMethod', 'Floor', ...
            'OverflowAction', 'Wrap', ...
            'ProductMode', 'SpecifyPrecision', ...
            'ProductWordLength', yLike.WordLength, ...
            'ProductFractionLength', 0, ...
            'SumMode', 'SpecifyPrecision', ...
            'SumWordLength', yLike.WordLength, ...
            'SumFractionLength', 0, ...
            'CastBeforeSum', true);

        a3 = setfimath(stripscaling(a),fma);
        siBiasA = setfimath(siBiasA,fma);

        a2 = removefimath( a3 + siBiasA );
    end
end
