function y = castToNoBias(u)


    % Copyright 2019-2023 The MathWorks, Inc.

    nt = fixed.extractNumericType(u);
    if nt.Bias == 0
        y = u;
    else
        siBias = fixed.internal.type.tightFi( nt.Bias / nt.Slope, 16 );

        u2 = stripscaling(u);

        temp = u2 + siBias;
        
        nty = fixed.internal.type.copyNewScaling(...
            temp.numerictype,...
            nt.Slope, 0 );

        y = reinterpretcast(temp,nty);
    end
end