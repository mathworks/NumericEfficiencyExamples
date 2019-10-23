% Test if elementwise multiplication is associative 
%    (A * B) * C  ==  A * (B * C)
% for various data types
% and for saturating vs wrapping flavors

clc
% Specify Input Attributes
defineCommonDataSpecifications

% Check Associativity
%
headline('Associativity of Multiplication Singles')
checkAssociativity(@times,dsSingleAll)

headline('Associativity of Multiplication Singles, Finite, Normal only')
checkAssociativity(@times,dsSingleBasic)

headline('Associativity of Saturating Multiplication int8')
checkAssociativity(@times,dsInt8)

headline('Associativity of Wrapping Multiplication int8')
checkAssociativity(@timesWrap,dsInt8)
headline('Associativity of Wrapping Multiplication uint8')
checkAssociativity(@timesWrap,dsUint8)
headline('Associativity of Wrapping Multiplication int32')
checkAssociativity(@timesWrap,dsInt32)
headline('Associativity of Wrapping Multiplication uint32')
checkAssociativity(@timesWrap,dsUint32)

headline('Associativity of Wrapping Multiplication fixdt(1,8,2)')
checkAssociativity(@timesWrap,dsSfix8_En2)

% Copyright 2019 The MathWorks, Inc.
