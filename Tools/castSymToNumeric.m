function y = castSymToNumeric(u,numType,opts)
    %castSymToNumeric convert symbolic to a numeric type
    
    
    %   Copyright 2019-2021 The MathWorks, Inc.
    
    assert(isa(u,'sym'))
    
    nt = fixed.internal.type.extractNumericType(numType);
    
    if isboolean(nt)
        
        y = logical(u);
        
    elseif fixed.internal.type.isAnyFloat(nt)
        
        if fixed.internal.type.isAnyDouble
            
            y = double(u);
            
        elseif fixed.internal.type.isAnySingle
            
            y = single(u);
            
        else
            assert( fixed.internal.type.isAnyHalf( nt ) );
            
            y = half( double( u ) );
        end
    else
        
        if ~exist('opts','var')
            opts = [];
        end
        
        y = handleOthers(u,nt,opts);
    end
end

function y = handleOthers(u,nt,opts)
    
    RoundingMethod = 'Nearest';
    %OverflowAction = 'Saturate';
    flag = 'r';
    
    if exist('opts','var') && ~isempty(opts)
        try
            RoundingMethod = opts.RoundingMethod;
        catch
        end
%         try
%             OverflowAction = opts.OverflowAction;
%         catch
%         end
        try
            flag = opts.flag;
        catch
        end
    end
    
    symBias = handleDoubleScalar(nt.Bias,flag);
    symSlope = 2.^sym(nt.FixedExponent) * ...
        handleDoubleScalar(nt.SlopeAdjustmentFactor,flag);
    
    siSym = (u-symBias)/symSlope;
    
    if nt.isscaleddouble
        ntStrip = fixed.internal.type.stripScaling(nt);
        
        y = fixed.internal.math.castUniversal(siSym,ntStrip);
        y = reinterpretcast(y,nt);
    else
        siSymRnd = roundSiSym(siSym,RoundingMethod);
        y = handleFixpt(siSymRnd,nt);
    end
end


function siSymRnd = roundSiSym(siSym,RoundingMethod)
    
    switch RoundingMethod
        
        case 'Floor'
            siSymRnd = floor(siSym);
            
        case 'Ceiling'
            
            siSymRnd = ceil(siSym);
            
        case 'Zero'
            
            siSymRnd = fix(siSym);
            
        case 'Nearest'
            
            siSymRnd = floor(siSym + 0.5);
            
        case 'Convergent'
            
            siSymRnd = floor(siSym + 0.5);
            
            isOdd = logical(mod( siSymRnd, 2 ));
            if isOdd
                tie = logical( 0.5 == abs( siSym - siSymRnd ) );
                if tie
                    siSymRnd = siSymRnd + roundUp;
                end
            end
            
        case 'Round'
            
            siSymRnd = floor(siSym + 0.5);
            
            isNeg = logical( siSymRnd < 0 );
            if isNeg
                tie = logical( 0.5 == abs( siSym - siSymRnd ) );
                if tie
                    siSymRnd = siSymRnd + roundUp;
                end
            end
            
        otherwise
            error('Unknown rounding method');
    end
end



function y = handleFixpt(siSymRnd,nt)
    
    ntStrip = fixed.internal.type.stripScaling(nt);
    
    y = fi( zeros(size(siSymRnd)), ntStrip );

    for i = 1:numel(siSymRnd)
        
        sc = siSymRnd(i);
        
        expLog10 = max(17,double( ceil( log10( abs( sc) ) ) ));
        
        % XXX need to handle non-finites
        %
        assert( isfinite(expLog10) );
    
        sValue = char( vpa( sc, expLog10 ) );
        
        y(i) = fi( 0, ntStrip, 'Value', sValue );
    end        
    y = reinterpretcast(y,nt);

end


function ySym = handleDoubleScalar(u,flag)
    
    if u == 0
        ySym = sym(0);
    elseif u == 1
        ySym = sym(1);
    elseif ('f' == flag) || ~isfinite(u)
        ySym = sym(u,'f');
    else
        f = fi(u,numerictype(1,64,abs(u),0));
        rp = fixed.internal.ratPlus(f);
        ySym = castToSym( rp );
    end
end
