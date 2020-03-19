function symEq = getMathEquationSym(op,u1,u2,y,u1Sym,u2Sym,ySuffix,verbose)
    %getMathEquationSym for math op get ideal symbolic equation for
    %computing the output stored integer value.
    %
    % Usage
    %   symEq = getMathEquationSym(op,u,u1Sym,y,ySuffix)
    % Input
    %   op  math op '+', '-', '*', '/'
    %   u1   specifies 1st input type using
    %       a value that implicitly specifies a type, e.g. single(pi)
    %       or a type name, e.g. 'double', 'sfix7_En7_B3'
    %       or a numerictype object, e.g. numerictype(1,7,2^-7,3)
    %   u2   specifies 2nd input type
    %   y   specifies output type
    %       if not given or empty, output scaling is treated as Symbolic
    %   u1Sym  specify symbol for the 1st input stored integer value. 
    %       Can be text or symbolic like 'intVarX' or sym('intVarX').
    %       Default is 'Qu1'.
    %   u2Sym  specify symbol for the 2nd input stored integer value. 
    %       Default is 'Qu2'.
    %   ySuffix when output type scaling is symbolic, specifies suffix
    %       for output Slope and Bias symbols. Default is 'y'.
    %   verbose logical that controls verbosity of symbolic output scaling
    %       default is false
    %
    
    % Copyright 2019 The MathWorks, Inc.

    if ~exist('u1','var')
        u1 = [];
    end
    symEqU1 = getVarScalingEquation(u1,'u1');
        
    if ~exist('u2','var')
        u2 = [];
    end
    symEqU2 = getVarScalingEquation(u2,'u2');
    
    switch op
        case '+'
            symEq = symEqU1 + symEqU2;
        case '-'
            symEq = symEqU1 - symEqU2;
        case '*'
            symEq = symEqU1 .* symEqU2;
        case '/'
            symEq = symEqU1 ./ symEqU2;
        otherwise
            error('Unknown math op')
    end

    if ~exist('y','var')
        y = [];
    end
    if ~exist('ySuffix','var')
        ySuffix = 'y';
    end
    if ~exist('verbose','var')
        verbose = false;
    end    
    [Sy,By] = getScaleTerms(y,ySuffix,verbose);
    
    symEq = ( symEq - By ) / Sy;
    
    symEq = simplify( expand( symEq) );
end
