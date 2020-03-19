function symEq = scaleEq(qStr,str2,str3,str4)
    %scaleEq get fixed-point scaling equation
    %
    % Usage
    %   symEq = suffixToScalingEquation(qStr,fixedExponentStr)
    %   symEq = suffixToScalingEquation(qStr,slopeStr,biasStr)
    %   symEq = suffixToScalingEquation(qStr,slopeAdjStr,fixedExponentStr,biasStr)
    
    % Copyright 2020 The MathWorks, Inc.

    q = sym(convertStringsToChars(qStr));
    
    switch nargin
        case 1
            symEq = q;
        case 2
            fe = (toSym(str2));            
            symEq = (2^fe) * q;
        case 3
            slope = (toSym(str2));            
            bias = (toSym(str2));            
            symEq = (slope * q) + bias ;            
        case 4
            slopeAdj = (toSym(str2));
            fe = (toSym(str3));            
            bias = (toSym(str4));            
            symEq = (slopeAdj * (2^fe) * q) + bias ;
        otherwise
            error('Too many arguments')
    end
end

function y = toSym(u)
    
    if isa(u,'sym')
        y = u;
    else
        y = sym(convertStringsToChars(u));
    end
end
