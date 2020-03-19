function dt = dtPairToOvercoat(dt1,dt2)
    %dtPairToOvercoat find type that can represent all values of a pair of
    %types
    
    % Copyright 2018-2019 The MathWorks, Inc.
    
    dt1 = fixed.internal.type.extractIntFixedBoolType(dt1);
    dt2 = fixed.internal.type.extractIntFixedBoolType(dt2);
    dt1 = fixed.internal.type.changeLogicalToUfix1(dt1);
    dt2 = fixed.internal.type.changeLogicalToUfix1(dt2);

    assert(fixed.internal.type.hasSameSlopeAdjustmentFactorSameBias(dt1,dt2));
    
    isSigned = dt1.Signed || dt2.Signed;
    if isSigned
        dt1b = sproutSignBit(dt1);
        dt2b = sproutSignBit(dt2);
    else
        dt1b = dt1;
        dt2b = dt2;
    end
    
    fe = min(...
        dt1b.FixedExponent ...
        ,dt2b.FixedExponent);
    
    msp2 = max(...
        dt1b.FixedExponent + dt1b.WordLength ...
        ,dt2b.FixedExponent + dt2b.WordLength);
    
    wl = msp2 - fe;
    
    
    dt = numerictype(...
        isSigned,...
        wl,...
        dt1b.SlopeAdjustmentFactor,...
        fe,...
        dt1b.Bias);
end


function dt = sproutSignBit(dt)
    %sproutSignBit if data type is unsigned, make it signed and one bit longer
    
    if ~dt.Signed
        dt.WordLength = dt.WordLength + 1;
        dt.Signed = true;
    end
end