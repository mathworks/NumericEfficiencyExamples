function show_subtract_extremes(dataTypeInput1,dataTypeInput2)
   %show_subtract_extremes show examples of the extreme range and precision
   %cases involved in subtraction
   %
   %Usage
   % show_subtract_extremes(dataTypeInput1,dataTypeInput2)
   
   % Copyright 2020 The MathWorks, Inc.

   dataTypeInput1 = fixed.internal.type.extractNumericType(dataTypeInput1);
   dataTypeInput2 = fixed.internal.type.extractNumericType(dataTypeInput2);
   
   v1 = getKeyExtremeValues(dataTypeInput1);
   % Force one argument to be signed to avoid case of 
   % unsigned minus unsigned not giving full precision result
   %
   dt1s = fixed.internal.type.sproutSignBit(dataTypeInput1);
   v1 = fi(v1,dt1s);   
     
   v2 = getKeyExtremeValues(dataTypeInput2);
   
   [y,u1,u2,dty] = outputExtremes(v1,v2);

   fprintf('\nAnalysis of extremes for subtraction\n')
   fprintf('  %s minus %s\n\n',dataTypeInput1.tostring,dataTypeInput2.tostring);
   
   fprintf('Some individual subtraction examples\n');
   for i=1:numel(y)
       fprintf('Example %d\n  row 1 is in1, row 2 is in2, row 3 is output\n',i);
       dispBinPtPrefer(u1(i),u2(i),y(i));
   end
   
   fprintf('Example extreme outputs shown together.\n');
   dispBinPtPrefer(y);
   
   fprintf('To losslessly represent all possible subtraction outputs\n')
   fprintf('the minimum bit span type is %s\n',dty.tostring)
   
end

function [y,u1,u2,dty] = outputExtremes(v1,v2)
    
   [v1,v2] = meshgrid(v1,v2);
   v1 = v1(:);
   v2 = v2(:);
   yFull = v1 - v2;
   dty = fixed.internal.type.tightFixedPointType(yFull);   
   
   [~,iMax] = max(yFull);
   [~,iMin] = min(yFull);

   iNeg = yFull < 0;
   if any(iNeg)
       vMaxNeg = max(yFull(iNeg));
       iMaxNeg = find(yFull == vMaxNeg,1);
   else
       iMaxNeg = [];
   end
   
   iPos = yFull > 0;
   if any(iPos)
       vMinPos = min(yFull(iPos));
       iMinPos = find(yFull == vMinPos,1);
   else
       iMinPos = [];
   end   
   ii = [iMin; iMaxNeg; iMinPos; iMax];
   
   y = yFull(ii);
   u1 = v1(ii);
   u2 = v2(ii);
   
   [y,ii]=sort(y);
   u1 = u1(ii);
   u2 = u2(ii);
end


function v = getKeyExtremeValues(dt)
    
    lo = fixed.internal.type.minFiniteRepresentableVal(dt);
    hi = fixed.internal.type.maxFiniteRepresentableVal(dt);
    loUp = fixed.internal.math.nextFiniteRepresentable(lo);
    hiDn = fixed.internal.math.prevFiniteRepresentable(hi);
    fz = fi(0,dt);
    fzUp = fixed.internal.math.nextFiniteRepresentable(fz);
    fzDn = fixed.internal.math.prevFiniteRepresentable(fz);
    v = [lo loUp fzDn fz fzUp hiDn hi].';
    v = fixed.internal.math.unique(v);
end