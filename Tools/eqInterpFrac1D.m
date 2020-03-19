function eq = eqInterpFrac1D(fracEq,yLoEq,yHiEq)
    
    eq = yLoEq + ( fracEq * (yHiEq - yLoEq) );
end
