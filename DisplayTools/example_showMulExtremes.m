clc
switch 'sfrac8'
    case 'int8'
        nt1 = numerictype(1,8,0);
        nt2 = numerictype(1,8,0);
        nt0 = numerictype(1,8,nt1.Slope*nt2.Slope*2^7,0);
    case 'sfrac8'
        nt1 = numerictype(1,8,7);
        nt2 = numerictype(1,8,7);
        nt0 = numerictype(1,8,nt1.Slope*nt2.Slope*2^7,0);
    case 'sfrac16'
        nt1 = numerictype(1,16,15);
        nt2 = numerictype(1,16,15);
        nt0 = numerictype(1,16,nt1.Slope*nt2.Slope*2^15,0);
    case 'sfrac32'
        nt1 = numerictype(1,32,31);
        nt2 = numerictype(1,32,31);
        nt0 = numerictype(1,32,nt1.Slope*nt2.Slope*2^31,0);
    case 'mix'
        nt1 = numerictype(1,8,4);
        nt2 = numerictype(1,8,2);
        nt0 = numerictype(1,8,nt1.Slope*nt2.Slope*2^7,0);
    otherwise
        error('Unknown type')
end
nt1 = numerictype(nt1.tostringInternalSlName);
nt2 = numerictype(nt2.tostringInternalSlName);
nt0 = numerictype(nt0.tostringInternalSlName);


fm = fimath('RoundingMethod', 'Floor', 'OverflowAction', 'Saturate');

doPrune = false;
[vIdeal,v1,v2] = showMulExtremes(nt1,nt2,doPrune);
v0 = fi(vIdeal,nt0,fm);

fprintf('Showing extreme range and precison examples for\n')
fprintf('multiplication of\n')
%fprintf('  Input1 of type %s aka %s aka %s\n',nt1.tostring,nt1.tostringInternalFixdt,nt1.tostringInternalSlName)
fprintf('        Input1 of type %s\n',nt1.tostringInternalFixdt)
fprintf('times   Input2 of type %s\n',nt2.tostringInternalFixdt)
%fprintf('  Input2 of type %s aka %s aka %s\n',nt2.tostring,nt2.tostringInternalFixdt,nt2.tostringInternalSlName)
%fprintf('  Input2 of type %s\n',nt2.tostringInternalFixdt)
fprintf('cast to Output    type %s\n',nt0.tostringInternalFixdt)
%fprintf('  Output type %s aka %s aka %s\n',nt0.tostring,nt0.tostringInternalFixdt,nt0.tostringInternalSlName)
%fprintf('  Output type %s\n',nt0.tostringInternalFixdt)
fprintf('with\n')
fprintf('    Overflows set to %s\n',fm.OverflowAction)
fprintf('    Rounding set to %s\n',fm.RoundingMethod)


dispBinPtInType(vIdeal)

slopeOut = nt0.Slope;
err = double(v0) - double(vIdeal);
%bitsOfError = err/slopeOut;

fprintf('\n\nIn the following examples\n')
fprintf('Row 1 is first input\n')
fprintf('Row 2 is second input\n')
fprintf('Row 3 is ideal product\n')
fprintf('Row 4 is final output from product cast to %s with %s %s\n',nt0.tostringInternalSlName,fm.OverflowAction,fm.RoundingMethod)

for i=1:numel(v0)
    dispBinPtPreferInType(v1(i),v2(i),vIdeal(i),v0(i))
    %dispBinIntMantExpAlignInType(v1(i),v2(i),vIdeal(i),v0(i))
    if 0 ~= err(i)
        fprintf('Quantization error %s\n',num2str(err(i),17));
        if abs(err(i)) >= slopeOut
        %if abs(bitsOfError(i)) >= slopeOut
            fprintf('Overflow occurred\n')
        end
    else
        fprintf('Lossless\n')
    end    
end


% Copyright 2019-2023 The MathWorks, Inc.

