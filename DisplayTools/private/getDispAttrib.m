function s = getDispAttrib(s)
    %getDispAttrib get display attributes
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    s.dispAttrib.actualMaxPow2Wt = s.Attrib.maxPow2Wt;
    s.dispAttrib.actualMinPow2Wt = s.Attrib.minPow2Wt;

    s1 = mat2str(s.Attrib.max_minPow2Wt,20);
    s2 = mat2str(s.Attrib.minPow2Wt,20);
    s.dispAttrib.expWidth = max(length(s1),length(s2));
    
    s.dispAttrib.widthIntMantExp = s.dispAttrib.expWidth + s.Attrib.maxBitSpan + 5;
    
    binPtMaxPow2Wt = max(-1,s.dispAttrib.actualMaxPow2Wt);
    binPtMinPow2Wt = min(0,s.dispAttrib.actualMinPow2Wt);
    
    s.dispAttrib.widthBinPt = binPtMaxPow2Wt + 1 - binPtMinPow2Wt + 1; % +1 for bin pt char
        
    s.dispAttrib.binPtMaxPow2Wt = binPtMaxPow2Wt;
    s.dispAttrib.binPtMinPow2Wt = binPtMinPow2Wt;
    
    switch s.opt.preferFormat
        case {'','auto'}
            tooWide = s.dispAttrib.widthBinPt > s.opt.maxDispWidthBits;
            useBinPt = (~tooWide) || ...
                ( s.dispAttrib.widthIntMantExp >= s.dispAttrib.widthBinPt);
            if useBinPt
                s.dispAttrib.dispFormat = 'BinPt';
            else
                s.dispAttrib.dispFormat = 'IntMantExp';
            end
        case 'IntMantExp'
            s.dispAttrib.dispFormat = 'IntMantExp';
        case 'Pedantic'
            s.dispAttrib.dispFormat = 'Pedantic';
        otherwise
            s.dispAttrib.dispFormat = 'BinPt';            
    end
     s.dispAttrib.useTrueBinPtDisp = strcmp(s.dispAttrib.dispFormat,'BinPt');
     s.dispAttrib.usePedantic = strcmp(s.dispAttrib.dispFormat,'Pedantic');
end
