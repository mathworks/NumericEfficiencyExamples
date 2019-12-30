function roundedRealWorldValue = roundBits(origRealWorldValue,numBits)
   % roundBits round input value to nearest binary value that only
   % used the specified number of bits
          
    % Copyright 2019 The MathWorks, Inc.

   f = fi(origRealWorldValue, origRealWorldValue < 0, numBits);
   
   roundedRealWorldValue = double(f);    
end