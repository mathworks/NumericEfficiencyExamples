fp = fipref;
fp.NumericTypeDisplay = 'short';
format compact
format long

nta = numerictype(0,4,3);
ntb = numerictype(1,4,3);
va = [
    upperbound(nta);
    lowerbound(nta);
];
vb = [
    upperbound(ntb);
    lowerbound(ntb);
];
y = va + vb
y.bin

nty_reduced = numerictype(1,6,4);
y_reduced = fi(y,nty_reduced)
y_reduced.bin


% Copyright 2019-2023 The MathWorks, Inc.
