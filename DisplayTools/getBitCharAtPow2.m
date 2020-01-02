function c = getBitCharAtPow2(u,p2Exp,extendRangeGiveSpaces,extendPrecisionGiveSpaces)
    %getBitCharAtPow2 from numeric scalar get bit at power of 2 location
    % 
    % For inputs that are not true fixed-point or integer types, the input 
    % will first be converted to a lossless minimum bit span
    % representation. For example, double(3.5) would be converted to 
    % fi(3.5,0,3,1).
    %
    % If the location specified is beyond the (converted) data type of the 
    % input, then optionally return a space or a bit value.
    % For the choice of returning a bit value,
    % if the location is beyond the precision end, then '0' is returned.
    % if the location is beyond the range end, then '0' is returned for 
    % non-negative values, and '1' is returned for negative values.
    %
    % Usage:
    %    c = getBitCharAtPow2(u,p2Exp,extendRangeGiveSpaces,extendPrecisionGiveSpaces)
    % Inputs
    %    u     real scalar numeric value
    %    p2Exp integer specifying desired bit corresponds to column with
    %          weight 2^p2Exp
    %    extendRangeGiveSpaces specifies handling bits beyond range end of the
    %          (converted) type of u. True gives spaces ' ', otherwise give
    %          give '1' for negative values and '0' for non-negative.
    %    extendPrecisionGiveSpaces specifies handling bits beyond precision 
    %          end of the (converted) type of u. True gives spaces ' ',
    %          otherwise give '0'.
    % Output
    %    c     a character with value '0', '1', or ' '
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    c = getBitOverPow2Range(u,p2Exp,p2Exp,extendRangeGiveSpaces,extendPrecisionGiveSpaces);
end
    
    
    
    
    