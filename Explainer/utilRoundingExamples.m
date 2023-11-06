function utilRoundingExamples(ntu,nty,roundingMethod,yAnchor,deltaC)


    % Copyright 2019-2023 The MathWorks, Inc.

    fm = fimath('RoundingMethod', roundingMethod, ...
        'OverflowAction', 'Saturate', ...
        'ProductMode', 'FullPrecision', ...
        'SumMode', 'FullPrecision');

    ntRound = fixed.internal.type.copyNewScaling( ntu, ...
        nty.SlopeAdjustmentFactor, nty.FixedExponent, nty.Bias);

    nRows = size(deltaC,1);

    for i=1:nRows

        uVDbl = double(yAnchor) + deltaC{i,1}*nty.Slope;

        uV = fi(uVDbl, ntu);

        roundV = removefimath( fi(uV,ntRound,fm) );
    
        yV = removefimath( fi(uV,nty,fm) );

        fprintf('\n%s\n',deltaC{i,2});

        dispSetOfValues(uV,roundV,yV);
    end
end


