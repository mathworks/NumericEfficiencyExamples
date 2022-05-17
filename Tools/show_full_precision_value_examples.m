clc
if 1
    slope = 0.05;
    fiTightSlope = fixed.internal.type.tightFi(slope);
    bias = 0;
    nt = numerictype(1,11,slope,bias);
else
    nt = numerictype(1,300,150);
end    
    
hi = fixed.internal.type.maxFiniteRepresentableVal( nt );
hi.Value
hiValueTraditional = castToSym(hi)
vpa(hiValueTraditional,50000)

hiValueTraditional = castToSym(hi,'r')

