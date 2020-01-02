function posInNegWorld = isPosInNegGroup(s,v)
    %isPosInNegGroup is positive in a group that includes negatives
    
    % Copyright 2019-2020 The MathWorks, Inc.

    posInNegWorld = s.Attrib.anyNegative && ~v.isNegative;
end
