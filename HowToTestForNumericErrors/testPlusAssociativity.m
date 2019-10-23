% Test if elementwise addition is associative 
%    (A + B) + C  ==  A + (B + C)
% for various data types
% and for saturating additon vs wrapping addition

clc
% Specify Input Attributes
defineCommonDataSpecifications

% Check Associativity
%
headline('Associativity of Addition Singles')
checkAssociativity(@plus,dsSingleAll)

headline('Associativity of Addition Singles, Finite, Normal only')
checkAssociativity(@plus,dsSingleBasic)

headline('Associativity of Saturating Addition int8')
checkAssociativity(@plus,dsInt8)

headline('Associativity of Wrapping Addition int8')
checkAssociativity(@plusWrap,dsInt8)
headline('Associativity of Wrapping Addition uint8')
checkAssociativity(@plusWrap,dsUint8)
headline('Associativity of Wrapping Addition int32')
checkAssociativity(@plusWrap,dsInt32)
headline('Associativity of Wrapping Addition uint32')
checkAssociativity(@plusWrap,dsUint32)

% Copyright 2019 The MathWorks, Inc.
