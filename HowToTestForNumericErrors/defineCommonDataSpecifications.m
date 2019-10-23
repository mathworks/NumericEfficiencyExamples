% Create fixed.DataSpecification objects
% for several interesting test cases
%
dsSingleAll = fixed.DataSpecification('single');
dsSingleBasic = fixed.DataSpecification('single',...
    'Interval',{-realmax,realmax},...
    'ExcludeDenormals', true, ...
    'ExcludeNegativeZero', true );
dsUint32 = fixed.DataSpecification('uint32');
dsInt32 = fixed.DataSpecification('Int32');
dsUint8 = fixed.DataSpecification('uint8');
dsInt8 = fixed.DataSpecification('Int8');

dsSfix8_En2 = fixed.DataSpecification(numerictype(1,8,2));

% Copyright 2019 The MathWorks, Inc.
