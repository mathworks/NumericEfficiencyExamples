function roundedRealWorldValue = roundBits(origRealWorldValue,numBits)
    % roundBits round input value to nearest binary value that only
    % used the specified number of bits
    
    % Copyright 2019 The MathWorks, Inc.
    
    isSigned = any( origRealWorldValue < 0, 'all' );
    f = fi(origRealWorldValue, isSigned, numBits);
    
    roundedRealWorldValue = double(f);
end
