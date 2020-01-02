function b = isNumericOrlogical(u)
    %isNumericOrlogical is input numeric or logical
    
    % Copyright 2019-2020 The MathWorks, Inc.

    b = isnumeric(u) || islogical(u); 
end
