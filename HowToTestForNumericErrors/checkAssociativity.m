function checkAssociativity(funcHandle,uDataSpecification)
    % Experimentally check if function satisfies associativity 
    % property for a given input specifcation.
    %
    % Are these equal?
    %    (A op B) op C  ==  A op (B op C)
    %
    dataSpec3X = cell(1,3);
    dataSpec3X(:) = {uDataSpecification};
    dg = fixed.DataGenerator('DataSpecifications',dataSpec3X);
    [v1,v2,v3] = dg.outputAllData;
    
    y1 = funcHandle( funcHandle(v1,v2), v3 );
    y2 = funcHandle( v1, funcHandle(v2,v3) );
    
    opt = sdOpt('(A op B) op C','A op (B op C)','A','B','C');
    showDifferences(y1, y2, opt, v1, v2, v3 );
end

% Copyright 2019 The MathWorks, Inc.
