% Examples using castIntToFi, castFiToInt, cast64BitIntToFi, cast64BitFiToInt

%   Copyright 2019 The MathWorks, Inc.

tNames = {
    'int8'
    'int16'
    'int32'
    'int64'
    'uint8'
    'uint16'
    'uint32'
    'uint64'
    'logical'
    'double'
    'single'
    'ufix1'
    'sfix11'
    'flts64'
    'fltu64'
    'ufix8_E1'
    'ufix8_En1'
    'ufix8_S1p5'
    'ufix8_B1'
    'ufix8_Bn1'
    };

for i=numel(tNames):-1:1
    v = fi(123,numerictype(tNames{i}));
    showConvert(v);    
end
fprintf('\n\n');
for i=1:numel(tNames)
    try
        v = cast(19,tNames{i});
        showConvert(v);
    end    
end
    
function showConvert(v)
    
    fprintf('\n   %-25s  %s\n','',v2Str(v));
    res('cast64BitFiToInt',v)
    res('castFiToInt',v)
    res('cast64BitIntToFi',v)
    res('castIntToFi',v)
end    

function res(fName,v)
    y = feval(fName,v);
    sv = v2Str(v);
    sy = v2Str(y);
    if strcmp(sv,sy)
        s = 'pass thru unchanged';
    else
        s = sy;
    end
    fprintf('   %-25s: %s\n',fName,s); 
end
    
function s = v2Str(v)
    if isfi(v)
        nt = numerictype(v);
        s = ['fi(',v.Value,',',nt.tostring,')'];
    else
        s = mat2str(v,20,'class');
    end
end
    
    