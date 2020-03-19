function symEq = getScalingEquationSym(u,storedIntegerSymbol)
    %getScalingEquationSym from type specified by input get its symbolic
    %Scaling Equation. This equation shows how the stored integer value
    %is converted to real world value.
    %
    % Rational recovery, doubleToSymRatRecovery, will be applied to the
    % Slope and Bias terms.
    %
    % Usage
    %   symEq = getScalingEquationSym(u,storedIntegerSymbol)
    % Input
    %   u   a value that implicitly specifies a type, e.g. single(pi)
    %       or a type name, e.g. 'double', 'sfix7_En7_B3'
    %       or a numerictype object, e.g. numerictype(1,7,2^-7,3)
    %   storedIntegerSymbol  optional argument to specify symbol for the
    %       stored integer. Can be text like 'intVarX' or symbolic like
    %       sym('intVarX'). Default is 'Qu'.
    %
    % Example: default stored integer symbol
    %   nt = numerictype(1,16,0.05,-0.20);
    %   eq1 = getScalingEquationSym(nt,'siSensor')
    %      siSensor/20 - 1/5
    %
    % Copyright 2019 The MathWorks, Inc.

    if ~exist('storedIntegerSymbol','var')
        storedIntegerSymbol = 'Qu';
    end
    storedIntegerSymbol = sym(storedIntegerSymbol);
            
    nt = fixed.internal.type.extractNumericType(u);
    
    symEq = ( storedIntegerSymbol * getSlopeSym(nt) ) + getBiasSym(nt);
end
