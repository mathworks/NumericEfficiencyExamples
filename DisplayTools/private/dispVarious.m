function dispVarious(varargin)
    %dispBinPt binary point display of input values
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    [opt,uNumeric] = splitOptionsFromNumerics(varargin{:});
    
    nNumeric = numel(uNumeric);
    
    nTot = getNumRealScalars(uNumeric{:});
    
    s.Attrib = groupNumAttrib('init');
    
    s.opt = setDefaultOptions(opt);
    
    s.vals = repmat(struct(),nTot,1);
    s.Attrib.origTypes = cell(1,nNumeric);
    
    idxScalar = 1;
    for iIn = 1:nNumeric
        u = uNumeric{iIn};
        s.Attrib.origTypes{iIn} = getInputType(u);
        [s,idxScalar] = processNumericInput(s,idxScalar,u);
    end
    s.Attrib = groupNumAttrib('finalize',s.Attrib,s.Attrib.origTypes,uNumeric,nTot); % finalize
    

    if s.opt.InType
        % Use combined overcoat type for display
        %
        fe = s.Attrib.typeOvercoatCombined.FixedExponent;
        wl = s.Attrib.typeOvercoatCombined.WordLength;
        s.Attrib.minPow2Wt = fe;
        s.Attrib.maxPow2Wt = wl - 1 + fe;
        s.Attrib.valsInOvercoatType = castAllToType(s.Attrib.typeOvercoatCombined,uNumeric,nTot);
    end        
     
    s = getDispAttrib(s);
    
    % Get maximum chars for real world value
    %
    ncRWV = 10;
    for i = 1:numel(s.vals)
        rwvStr = fmtRWV(s,s.vals(i));
        ncRWV = max(ncRWV,length(rwvStr));
    end
    s.dispAttrib.nCharsRWV = ncRWV;
    
    if s.Attrib.anyNegative
        fprintf('\nNegative values present: Two''s Complement Encoding shown\n\n');
    else
        fprintf('\nAll values non-negative: Unsigned Encoding shown\n\n');
    end

    if s.dispAttrib.usePedantic
        s = dispPedanticHeader(s);
    else
        s = dispBinHeader(s);
    end
        
    for i=1:nTot
        dispScalar(s,i);
    end
end


function opt = setDefaultOptions(opt)

    defOpt.maxDispWidthBits = 80;
    defOpt.preferFormat = '';
    defOpt.InType = false;
    
    if isempty(opt)
        opt = defOpt;
    else
        fns = fieldnames(defOpt);
        for i=1:numel(fns)
            fn = fns{i};
            if ~isfield(opt,fn)
                opt.(fn) = defOpt.(fn);
            end
        end        
    end
end

function rwvStr = fmtRWV(s,v)
    % get formated real world value
    %        
    rwvStr = compactButAccurateDecStr(v.minBitSpanFi);
    %if isPosInNegGroup(s,v)
    %    rwvStr = [' ',rwvStr];
    %end
end


function dispScalarBinPt(s,v)
    % binary point diplay of scalar
    %    get integer and fraction bits
    %    
    assert(s.dispAttrib.useTrueBinPtDisp);
    
    [intBits,fracBits] = getIntFracBitsForDisp(s,v);
    
    fmt = sprintf('%%%ds.%%-%ds\n',...
        s.dispAttrib.binPtMaxPow2Wt+1,-s.dispAttrib.binPtMinPow2Wt);
    
    printRWV(s,1,fmtRWV(s,v));
    fprintf(fmt,intBits,fracBits);
end


function dispScalarIntMantExp(s,v)
    % binary point diplay of scalar
    %    get integer and fraction bits
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);

    n1 = s.Attrib.maxBitSpan;
    n2 = s.dispAttrib.expWidth;

    fmtZ= sprintf('%%%ds     %%-%ds\n',...
        n1,n2);
    fmt = sprintf('%%%ds * 2^%%-%dd\n',...
        n1,n2);

    printRWV(s,1,fmtRWV(s,v));

    if v.isZero
        fprintf(fmtZ,'0','');
    else
        sBin = v.minBitSpanFi.bin;
        fe = v.FixedExponent;
        if isPosInNegGroup(s,v)
            sBin = ['0',sBin];
        end
        fprintf(fmt,sBin,fe);
    end
end


function dispScalarPedantic(s,v)
    % Pedantic binary display of scalar
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);
    assert(s.dispAttrib.usePedantic);
    
    useType = s.opt.InType;
    extendRangeGiveSpaces = ~useType && ~s.Attrib.anyNegative; 
    extendPrecisionGiveSpaces = ~useType;
    
    bits = getBitOverPow2Range(v.minBitSpanFi,...
        s.dispAttrib.binPtMinPow2Wt,...
        s.dispAttrib.binPtMaxPow2Wt,...
        extendRangeGiveSpaces,extendPrecisionGiveSpaces);

%     uOver = fi(v.minBitSpanFi,s.Attrib.typeOvercoatOfAllMinBitSpans);
%     bits = uOver.bin;

    printRWV(s,1,fmtRWV(s,v));
    
    for i = 1:s.pedantic.nCols
        printCenter(bits(i),s.pedantic.fullColWidth);
    end
    
    fprintf('\n');
end


function s = dispBinHeader(s)
    % Header for binary display
    %    
    assert(~s.dispAttrib.usePedantic);

    bp = s.dispAttrib.useTrueBinPtDisp;
    if bp
        s1 = 'Binary Point';
        s2 = '';
    else
        s1 = 'Integer Mantissa';
        s2 = '    and Pow2 Exponent';
    end    
    
    printRWV(s,0,'Real World');
    fprintf('Notation: %s\n',s1)
    printRWV(s,0,'Value');
    fprintf('  %s\n',s2);
end

function s = dispPedanticHeader(s)
    % Pedantic binary display of scalar
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);
    assert(s.dispAttrib.usePedantic);
    
    p2Hi = s.dispAttrib.actualMaxPow2Wt;
    p2Lo = s.dispAttrib.actualMinPow2Wt;
    
    nCols = p2Hi - p2Lo + 1;
    maxLengthLabels = 0;
    colPow2Labels = cell(1,nCols);
    colDecLabels = cell(1,nCols);
    p2Vec = p2Hi:-1:p2Lo;
    for i=1:nCols
        p2 = p2Vec(i);
        curLabel = sprintf('2^%d',p2);
        curLabel2 = mat2str(2^p2,19);
        if p2 == p2Hi && s.Attrib.anyNegative
            curLabel = ['-',curLabel];
            curLabel2 = ['-',curLabel2];
        end
        curLen = length(curLabel);
        curLen2 = length(curLabel2);
        if curLen2 > 7
            curLabel2 = '';
            curLen2 = 0;
        end
        maxLengthLabels = max(maxLengthLabels,max(curLen,curLen2));
        colPow2Labels{i} = curLabel;
        colDecLabels{i} = curLabel2;
    end

    s.pedantic.fullColWidth = maxLengthLabels + 2;

    printRWV(s,0,'');
    totWidth = min(80,nCols * s.pedantic.fullColWidth);
    printCenter('Weighted Bit Columns',totWidth);
    fprintf('\n')
    
    colFmt = sprintf(' %%%ds ',maxLengthLabels);
%     nNotBit = maxLengthLabels + 2 - 1;
%     nAfter = ceil(nNotBit/2);
%     bBefore = nNotBit - nAfter;
%     bitFmt = sprintf('%s%%s%s',repmat(' ',1,bBefore),repmat(' ',1,nAfter));
    
    printRWV(s,0,'');
    delx = repmat('-',1,maxLengthLabels);
    
    rowDelx(nCols,colFmt,delx);

    printRWV(s,0,'Real World');
    for i = 1:nCols
        %fprintf(colFmt,colPow2Labels{i});
        printCenter(colPow2Labels{i},s.pedantic.fullColWidth);
    end
    fprintf('\n')

    printRWV(s,0,'Value');
    for i = 1:nCols
        printCenter(colDecLabels{i},s.pedantic.fullColWidth);
    end
    fprintf('\n')
    printRWV(s,0,'');
    rowDelx(nCols,colFmt,delx);

    s.pedantic.nCols = nCols;
    s.pedantic.colFmt = colFmt;
    %s.pedantic.bitFmt = bitFmt;
    s.pedantic.p2Vec = p2Vec;
end

function rowDelx(nCols,colFmt,delx)
    for i = 1:nCols
        fprintf(colFmt,delx);       
    end
    fprintf('\n');
end



function dispScalar(s,i)
    v = s.vals(i);
    
    if isfinite(v.minBitSpanFi)        
        if s.dispAttrib.useTrueBinPtDisp
            dispScalarBinPt(s,v);
        elseif s.dispAttrib.usePedantic
            dispScalarPedantic(s,v);
        else
            dispScalarIntMantExp(s,v);
        end
    else
        %fprintf('  %s\n',mat2str(double(v.minBitSpanFi)));
        printRWV(s,0,mat2str(double(v.minBitSpanFi)));
        fprintf('\n');
    end
end


function dt = getInputType(u)
   dt = fixed.internal.type.extractNumericType(u); 
   dt = fixed.internal.type.changeLogicalToUfix1(dt);
end

function printRWV(s,useEqual,str)
    fprintf(' ');
    printCenter(str,s.dispAttrib.nCharsRWV);
    if useEqual
        fprintf(' = ');
    else
        fprintf('   ');
    end
end
