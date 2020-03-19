function symEq = getInterpEquationSym(ut,breakt,tablet,yt,evenSpacingValue)
    %getMathEquationSym for math op get ideal symbolic equation for
    %computing the output stored integer value.
    %
    % Usage
    %   symEq = getMathEquationSym(op,u,u1Sym,y,ySuffix)
    % Input
    %   ut   specifies 1st input type using
    %       a value that implicitly specifies a type, e.g. single(pi)
    %       or a type name, e.g. 'double', 'sfix7_En7_B3'
    %       or a numerictype object, e.g. numerictype(1,7,2^-7,3)
    %   breakt   pecifies breakpoint type
    %   tablet   specifies table type
    %   yt       specifies output type
    %   evenSpacingValue for evenly spaced tables gives spacing value
    %            if not given or empty, then uneven spacing                
    
    % Copyright 2019 The MathWorks, Inc.

    if ~exist('ut','var')
        ut = [];
    end
    if ~exist('breakt','var')
        breakt = [];
    end
    if ~exist('tablet','var')
        tablet = [];
    end
    if ~exist('yt','var')
        yt = [];
    end
    if ~exist('evenSpacingValue','var')
        evenSpacingValue = [];
    end
    
    symEqU = getVarScalingEquation(ut,'u');        
    symEqBLeft = getVarScalingEquation(breakt,'bl','b');
    
    symNumDelta = symEqU - symEqBLeft;
    
    if isempty(evenSpacingValue)

        symEqBRght = getVarScalingEquation(breakt,'br','b');
        symDenDelta = symEqBRght - symEqBLeft;
    else
        symDenDelta = doubleToSymRatRecovery(evenSpacingValue);        
    end

    symEqTableLeft = getVarScalingEquation(tablet,'tl','t');
    symEqTableRght = getVarScalingEquation(tablet,'tr','t');
    synNumDelta2 = symEqTableRght - symEqTableLeft;

    symEq = symEqTableLeft + ( ( symNumDelta .* synNumDelta2 ) ./ symDenDelta );
    
    [Sy,By] = getScaleTerms(yt,'y',false);
    
    symEq = ( symEq - By ) / Sy;
    
    symEq = simplify( symEq, 10 );
    symEq = simplifyFraction( symEq );
    %symEq = simplify( expand( symEq) );
    symEq = simplify( symEq, 10 );
end
