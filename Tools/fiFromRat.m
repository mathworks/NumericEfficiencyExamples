function y = fiFromRat(num,den,wordLength,roundingMethod)

    q = castToSym(num) ./ castToSym(den);

    
    iiIsNeg = logical( q < 0 );
    
    isSigned = any( iiIsNeg );
    
    q2 = q;
%     if isSigned
        q2(iiIsNeg) = abs(q(iiIsNeg));
%     else
        q2(~iiIsNeg) = q(~iiIsNeg) .* (1 + (sym(2)^(-wordLength)));
%     end
    maxExp = double( ceil( log2( max( q2 ) ) ) );
    
    nDigits1 = ceil( log10(2) * wordLength ) + 10;
    nDigits = max( 17, nDigits1 );
    
    v = vpa( q, nDigits );

    fixedExp = maxExp - wordLength + isSigned;

    nExtra = 16;
    yExtraPrecise = fi(zeros(size(q)),isSigned,wordLength+nExtra,-fixedExp+nExtra);
    
    for i=1:numel(v)
        curScalar = yExtraPrecise(i);
        vStr = char(v(i));
        curScalar.Value = vStr;
        yExtraPrecise(i) = curScalar;
    end
    
    if ~exist('roundingMethod','var') || isempty(roundingMethod)
        y = fi(yExtraPrecise,isSigned,wordLength,-fixedExp);
    else
        y = fi(yExtraPrecise,isSigned,wordLength,-fixedExp,...
            'RoundingMethod',roundingMethod);                
    end
    y = removefimath(y);
end
