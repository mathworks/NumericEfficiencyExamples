function bFitsInDouble = typeFitsInDouble(u)
    %typeFitsInDouble is type specified by input a subset of double
    %
    % TU = Type specified by u.
    %
    % TU being a subset of double means that all values representable
    % by TU are losslessly representable in double.
    % 
    % single, uint32, logical, numerictype(1,50,25)   
    % are examples of types that are subsets of double
    %
    % int64, uint64, numerictype(0,55,0) 
    % are examples of types that are not subsets of double.
    % Those types represent values, such as intmax('uint64'), that cannot
    % be losslessly represented in double. 
    %

    % Copyright 2019 The MathWorks, Inc.

    ntDouble = numerictype('double');
    ntu = fixed.internal.type.extractNumericType(u);
    
    bFitsInDouble = fixed.internal.type.isTypeSuperset(ntDouble,ntu);
end
