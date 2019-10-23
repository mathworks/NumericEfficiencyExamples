% Show examples of the many possible bit encodings for NaN
%
fprintf('\nMATLABs canonical NaN\n');
showValue(nan);

fprintf('\nRandom selection of other encodings of NaN\n');

bitsOfMaxExp = uint64(fi([],0,64,0,'hex','7ff0000000000000'));
bitsOfSign   = uint64(fi([],0,64,0,'hex','8000000000000000'));

for i=1:8
    u = bitsOfMaxExp;
    if rand(1,1) > 0.5
        u = bitor(u,bitsOfSign);
    end
    nonHiddenMantissaBits = uint64(randi([1,(flintmax/2)],1,1));
    u = bitor(u,nonHiddenMantissaBits);
    u = typecast(u,'double');
    showValue(u);
end


function showValue(u)
    fprintf('%s\n',repmat('-',1,70));
    if isfloat(u)
        sEncoding = num2hex(u);
    else
        fu = fi(u);
        sEncoding = fu.hex;
    end
    
    fprintf('Hex encoding %s == %s ==  %s\n',...
        sEncoding, mat2str(u),mat2str(u,'class',25));
end

% Copyright 2019 The MathWorks, Inc.
