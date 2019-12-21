function assertNeedOlderThanR2020a() %#codegen
    %assertNeedOlderThanR2020a report error if R2020a or newer
    
    %   Copyright 2019 The MathWorks, Inc.
    
    coder.inline('always');

    coder.extrinsic('verLessThan');
    verOlderThanR2020a = coder.const(verLessThan('matlab', '9.8'));
    
    assert(verOlderThanR2020a,...
        sprintf('%s%s%s',...
        'This set of shim functions in this folder is not needed in R2020a or later. ',...
        'Please use the versions of these functions that ship in R2020a and later. ', ...
        'To achieve that, simply remove the folder containing this function from your path. '));
end
