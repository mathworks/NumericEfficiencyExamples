function symEq = getCastEquationSym(u,y,uSISym,ySuffix,verbose)
    %getCastEquationSym for a cast get ideal symbolic equation for
    %computing the output stored integer value.
    %
    % Usage
    %   symEq = getCastEquationSym(u,uSISym,y,ySuffix)
    % Input
    %   u   specifies input type using
    %       a value that implicitly specifies a type, e.g. single(pi)
    %       or a type name, e.g. 'double', 'sfix7_En7_B3'
    %       or a numerictype object, e.g. numerictype(1,7,2^-7,3)
    %   y   specifies output type
    %       if not given or empty, output scaling is treated as Symbolic
    %   uSISym  specify symbol for the input stored integer value. 
    %       Can be text or symbolic like 'intVarX' or sym('intVarX').
    %       Default is 'Qu'.
    %   ySuffix when output type scaling is symbolic, specifies suffix
    %       for output Slope and Bias symbols. Default is 'y'.
    %   verbose logical that controls verbosity of symbolic output scaling
    %       default is false
    %
    % Example: 
    %   getCastEquationSym(fixdt(0,16,7,9))
    %     (7*Qu - By + 9)/Sy
    %
    %   getCastEquationSym(fixdt(0,16,7,9),[],'varX')
    %     (7*varX - By + 9)/Sy
    %
    %   getCastEquationSym(fixdt(0,16,7,9),[],'varX','_out',true)
    %     (7*varX - Bias_out + 9)/Slope_out
    %
    %   getCastEquationSym(fixdt(0,16,7,9),fixdt(1,16,11,17))
    %      (7*Qu)/11 - 8/11
    
    % Copyright 2019 The MathWorks, Inc.

    if ~exist('uSISym','var') || isempty(uSISym)
        uSISym = 'Qu';
    end
    uSISym = sym(uSISym);
    symEqU = getScalingEquationSym(u,uSISym);
    
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
    
    symEq = ( symEqU - By ) / Sy;
end
