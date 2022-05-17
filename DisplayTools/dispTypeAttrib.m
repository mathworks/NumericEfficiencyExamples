function dispTypeAttrib(varargin)
    %dispTypeAttrib display attributes of a type
    %
    % Example:
    % dispTypeAttrib(numerictype(1,3,1))
    %
    % Negative values present: Two's Complement Encoding shown
    %
    %  Real World   Notation: Binary Point
    %     Value
    %     3.125   =  011.001
    %     -0.25   =     .110
    %       4     = 0100.
      
    % Copyright 2019-2020 The MathWorks, Inc.

    nt = fixed.internal.type.extractNumericType(varargin{i});
    
    fprintf('%s attributes\n',nt.tostring);
    
    
    
    
    
    
    dispVarious(struct('preferFormat','BinPt','InType',true),varargin{:});
end

