clc
hr = repmat('-',1,65);

%-----------------------------------
s = 'Add';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

symAdd0 = getMathEquationSym('+')

s1 = 7;
b1 = -11*s1;
ntu1 = numerictype(0,16,s1,b1);
s2 = 5;
b2 = -17*s2;
ntu2 = numerictype(0,16,s2,b2);

symAdd1 = getMathEquationSym('+',ntu1,ntu2)

sy1 = 7/256;
by1 = -162;
nty1 = numerictype(0,16,sy1,by1);
symAdd2 = getMathEquationSym('+',ntu1,ntu2,nty1)

%-----------------------------------
s = 'Subtract';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

symSub0 = getMathEquationSym('-')
symSub1 = getMathEquationSym('-',ntu1,ntu2)
sy2 = 7/256;
by2 = 8;
nty2 = numerictype(0,16,sy2,by2);
symSub2 = getMathEquationSym('-',ntu1,ntu2,nty2)

%-----------------------------------
s = 'Mul';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

symMul0 = getMathEquationSym('*')
symMul1 = getMathEquationSym('*',ntu1,ntu2)
sy3 = 5*7;
by3 = 77*85;
nty3 = numerictype(0,16,sy3,by3);
symMul2 = getMathEquationSym('*',ntu1,ntu2,nty3)


%-----------------------------------
s = 'Div';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

symDiv0 = getMathEquationSym('/')
symDiv1 = getMathEquationSym('/',ntu1,ntu2)
sy3 = 7/5;
by3 = 0;
nty4 = numerictype(0,16,sy3,by3);
symDiv2 = getMathEquationSym('/',ntu1,ntu2,nty4)

%-----------------------------------
s = 'Interp';
%-----------------------------------
fprintf('%s\n%s\n%s\n',hr,s,hr)

symEqInterp0 = getInterpEquationSym()
symEqInterp1 = getInterpEquationSym(ntu1,ntu1,ntu2,ntu2)
symEqInterp2 = getInterpEquationSym(ntu1,ntu1,ntu2,ntu2,16*ntu1.Slope)

if 0
Fi = sym('Fi');
Eb = sym('Eb');
Sb = sym('Sb');
Eu = sym('Eu');
Su = sym('Su');

Fo = sym('Fo');
Ey = sym('Ey');
Et = sym('Et');
Sy = sym('Sy');
St = sym('St');

Qy = sym('Qy');

s = solve(Qy==symEqInterp0,Su==Fi*2^Eu,Sb==Fi*2^Eb,Sy==Fo*2^Ey,St==Fo*2^Et,Qy)
end
