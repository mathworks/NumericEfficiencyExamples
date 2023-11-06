nt1 = numerictype(1,8,7);
nt2 = numerictype(1,8,7);
nt0 = numerictype(1,8,nt1.Slope*nt2.Slope*2^7,0);

nt1 = numerictype(nt1.tostringInternalSlName);
nt2 = numerictype(nt2.tostringInternalSlName);
nt0 = numerictype(nt0.tostringInternalSlName);

[vIdeal,v1,v2] = showMulExtremes(nt1,nt2,true);
ntIdeal = fixed.internal.type.extractNumericType(vIdeal);

fmFloor = fimath('RoundingMethod', 'Floor', 'OverflowAction', 'Saturate');
fmCeiling = fimath('RoundingMethod', 'Floor', 'OverflowAction', 'Saturate');

%desiredProduct = fixed.internal.math.prevFiniteRepresentable(fixed.internal.math.prevFiniteRepresentable(max(vIdeal(:))));
desiredProduct = fixed.internal.math.prevFiniteRepresentable(vIdeal(end-1));


u1 = fi( nt1.Slope.*[-128:-1,1:127].', nt1);
u2 = fi( nt2.Slope.*[-128:-1,1:127].', nt2);
[uu1,uu2] = meshgrid(u1,u2);

p4 = fixed.internal.math.unique( uu1(:).*uu2(:) );
nt4 = numerictype(p4);

subplot(1,1,1)
%plot(p4,'.')
plot(p4(2:end),diff(double(p4))/nt4.Slope,'-')
shg
return









u2Dbl = double(desiredProduct)./double(u1);

hiPlus = double(upperbound(nt2)) + nt2.Slope/2;
loPlus = double(lowerbound(nt2)) - nt2.Slope/2;

iiDrop = u2Dbl < loPlus | hiPlus < u2Dbl;

u1(iiDrop) = [];
u2Dbl(iiDrop) = [];

u2 = [
    removefimath(fi(u2Dbl,nt2,fmFloor))
    removefimath(fi(u2Dbl,nt2,fmCeiling))
    ];
u1 = [u1;u1];

p3 = u1.*u2;

dispBinPtInType(sort(p3))

return

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
