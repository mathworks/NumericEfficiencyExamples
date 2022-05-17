function y = castToSym(u,flag)
    %castToSym convert any numeric or logical value to Symbolic Toolbox value
    %
    % The function provides two ways to treat terms involving double precision.
    % One approach converts terms involving double as the exact value stored
    % in memory. This is similar to sym(u,'f').
    % The other approach seeks to recover the simplest rational that would 
    % quantized to same double term. This similarities (and differences)
    % to sym(u,'r').
    %
    % y = castToSym(u,opt)
    % Output
    %     y is a symbolic toolbox sym variable
    % Input
    %     u    input numeric or logical value
    %     flag option to control handling of terms involving floating point doubles.
    %          The default is 'f'.
    %    
    %          'f' stands for 'floating point'.  All values are transformed from
    %          double precision to exact numeric values N*2^e for integers N and e.
    %          If the input u floating point, then the output is the same as
    %          sym( u,'f').
    %
    %          'r' stands for 'rational recovery'. The value used for the double
    %          will be the rational p/q with the "smallest" integers where
    %          the rational would quantize back to a double with the same value 
    %          as the original double.
    %
    %          The are two cases where double is involved.
    %
    %          The first case is when the input u is floating-point. In this
    %          case, the input cast to double beforce converting to symbolic.
    %          
    %          The second case is when the input u has fixed-point scaling
    %          with a non-unit SlopeAdjustmentFactor or non-zero Bias.
    %             V = S * Q + B
    %             S = F * 2^E;
    %          where
    %             S = Slope                 (not stored, defined by equation)
    %             F = SlopeAdjustmentFactor (stored as a double)
    %             E = FixedExponent         (stored as an integer)
    %             B = Bias                  (stored as a double)
    %          
    %          For the common cases of -1022 <= E <= 1023,
    %          the converstion to symbolic is computed as.
    %             castToSym(S,flag) * Q + castToSym(B,flag)
    %
    % Example 1
    %    slopeDouble = 0.05000000000000000277556;
    %    slopeExactDouble = castToSym( slopeDouble, 'f' )
    %    slopeRationalRecovery = castToSym( slopeDouble, 'r' )
    %
    %   slopeExactDouble =
    %      3602879701896397/72057594037927936
    %   slopeRationalRecovery =
    %      1/20
    %
    %  Notice that
    %      slopeExactDouble == sym( slopeDouble, 'f')
    %    
    % Example 2
    %   slopeDouble = 0.05000000000000000277556;
    %   uSlopeBiasFi = fi( 13*slopeDouble, 1, 8, slopeDouble, 0 );
    %   uSlopeBiasStoredInteger = uSlopeBiasFi.storedInteger
    %   y_w_ScalingExactDoubles = castToSym( uSlopeBiasFi, 'f' )
    %   y_w_ScalingRationalRecovery = castToSym( uSlopeBiasFi, 'r' )
    %
    %   uSlopeBiasStoredInteger =
    %     int8
    %      13
    %   y_w_ScalingExactDoubles = 
    %     46837436124653161/72057594037927936
    %   y_w_ScalingRationalRecovery =
    %     13/20
    %
    %  Notice that 
    %   y_w_ScalingExactDoubles == uSlopeBiasStoredInteger * slopeExactDouble
    %   y_w_ScalingRationalRecovery == uSlopeBiasStoredInteger * slopeRationalRecovery
    %
    % see also: sym, vpa
    
    %   Copyright 2019-2020 The MathWorks, Inc.
    
    if isa(u,'sym')
        y = u;
        return
    end
    
    if isa(u,'fixed.internal.ratPlus')
        y = castToSym( u.signedFullNum ) ./ castToSym( u.fullDen );
        return
    end
    
    nt = fixed.internal.type.extractNumericType(u);
    
    if ~exist('flag','var')
        flag = 'f';
    end
    switch flag
        case 'f'
            doExactFloat = 1;
        case 'r'
            doExactFloat = 0;
        otherwise
            assert(1,'unknown value for second input flag');
    end
    
    if ( isboolean(nt) || ...
            fixed.internal.type.isAnyFloat(nt) )
        
        u = double(u);
        
        % Compute assuming 'f' mode
        %   if it is actually 'r' mode this step serves to 
        %   layout the memory for the output. Scalar only steps will
        %   then replace the individual values
        %
        y = sym(u,'f'); 
        
        if ~doExactFloat
            for i=1:numel(y)
                %
                % For 'r' mode, fill in each individual scalar output
                % 
                y(i) = handleDoubleScalar(u(i),flag);
            end
        end
    else
        u = fixed.internal.math.castIntToFi(u);
        storedInteger = stripscaling(u);
        
        % Size the output
        %
        y = sym(zeros(size(storedInteger)));
        %
        % Initialized the output with the symbolic representation
        % of the stored integer
        %
        for i=1:numel(y)
            curSI = storedInteger(i);
            %
            % Next step assumes fi Value method is lossless for all
            % cases with trivial scaling.
            % If that is not true, then there could be a lose of precision.
            %
            y(i) = sym(curSI.Value);
        end        
        
        
        % Handle Slope terms
        %   S = F * 2^E
        %   V = S * Q
        %        
        unitSlopeAdjustmentFactor = 1 == nt.SlopeAdjustmentFactor;

        if unitSlopeAdjustmentFactor
            %
            % handle just FixedExponent
            %
            y = y .* (2.^sym(nt.FixedExponent));
            
        elseif doExactFloat
            %
            % For 'f' mode, the terms of S = F * 2^E can be handled
            % individually 
            % 
            % handle non-trivial SlopeAdjustmentFactor
            % in exact mode 'f'
            %
            symSlopeAdjust = handleDoubleScalar(nt.SlopeAdjustmentFactor,flag);
            y = y .* symSlopeAdjust;
            %
            % handle FixedExponent
            %
            y = y .* (2.^sym(nt.FixedExponent));
        else
            %
            % handle non-trivial SlopeAdjustmentFactor
            % in rational recovery mode 'f'
            %
            slope = fixed.internal.type.getSlopeValueInBiasFreeType(nt);
            ratSlope = fixed.internal.ratPlus(slope);
            symSlope = castToSym(ratSlope);
            y = y * symSlope;
        end
        
        % Handle Bias
        %
        if 0 ~= nt.Bias
            symBias = handleDoubleScalar(nt.Bias,flag);
            y = y + symBias;
        end
    end
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
