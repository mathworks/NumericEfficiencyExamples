function eq = eqInterp1D(uEq,uLoEq,uHiEq,yLoEq,yHiEq)
    
    eq = yLoEq + ( ( (uEq - uLoEq) * (yHiEq - yLoEq) ) / (uHiEq - uLoEq) );
end
