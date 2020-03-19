function symEq = mySimplify(symEq)
    symEq = simplify( symEq, 10 );
    symEq = simplifyFraction( symEq );
    %symEq = simplify( expand( symEq) );
    symEq = simplify( symEq, 10 );
end
