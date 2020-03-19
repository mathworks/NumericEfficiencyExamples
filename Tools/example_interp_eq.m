clc
hr = repmat('-',1,65);

ySlope = sym('Fy')*2^sym('Ey');
yBias = sym('By');

%-----------------------------------
s = 'Interp_1D';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

u   = scaleEq('Qu','Fu','Eu','Bu');
bL  = scaleEq('QuL','Fu','Eb','Bu');
bH  = scaleEq('QuH','Fu','Eb','Bu');

tL  = scaleEq('QyL','Fy','Et','By');
tH  = scaleEq('QyH','Fy','Et','By');

eq1D = (eqInterp1D(u,bL,bH,tL,tH) - yBias) / ySlope;
eq1D = mySimplify(eq1D)

%-----------------------------------
s = 'Interp_2D';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

Eu1 = sym('Eu1');
Eb1 = Eu1+sym('ubs1');
u1   = scaleEq('Qu1','Fu1',Eu1,'Bu1');
b1L  = scaleEq('Q1L','Fu1',Eb1,'Bu1');
b1H  = scaleEq('Q1H','Fu1',Eb1,'Bu1');

Eu2 = sym('Eu2');
Eb2 = Eu2+sym('ubs2');
u2   = scaleEq('Qu2','Fu2',Eu2,'Bu2');
b2L  = scaleEq('Q2L','Fu2',Eb2,'Bu2');
b2H  = scaleEq('Q2H','Fu2',Eb2,'Bu2');

yLL = scaleEq('QyLL','Fy','Et','By');
yLH = scaleEq('QyLH','Fy','Et','By');
yHL = scaleEq('QyHL','Fy','Et','By');
yHH = scaleEq('QyHH','Fy','Et','By');

yiL = eqInterp1D(u1,b1L,b1H,yLL,yHL);
yiH = eqInterp1D(u1,b1L,b1H,yLH,yHH);
eq2D = (eqInterp1D(u2,b2L,b2H,yiL,yiH) - yBias) / ySlope;
eq2D = mySimplify(eq2D)

%-----------------------------------
s = 'Interp_1D_Frac';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

u   = scaleEq('Qu','Fu','Eu','Bu');
bL  = scaleEq('QuL','Fu','Eb','Bu');
bH  = scaleEq('QuH','Fu','Eb','Bu');

fracEq = 2^sym('Ef')*(sym('Qf')+sym('errQf'));

tL  = scaleEq('QyL','Fy','Et','By');
tH  = scaleEq('QyH','Fy','Et','By');

eq1DFrac = (eqInterpFrac1D(fracEq,tL,tH) - yBias) / ySlope;
eq1DFrac = mySimplify(eq1DFrac)



