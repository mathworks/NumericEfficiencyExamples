function dispVarious(varargin)
    %dispBinPt binary point display of input values
    
    % Copyright 2019 The MathWorks, Inc.
    
    [opt,uNumeric] = splitOptionsFromNumerics(varargin{:});
    
    nNumeric = numel(uNumeric);
    
    nTot = getNumRealScalars(uNumeric{:});
    
    s.Attrib = groupNumAttrib();
    
    s.opt = setDefaultOptions(opt);
    
    s.v = repmat(struct(),nTot,1);
    s.origTypes = cell(1,nNumeric);
    
    idxScalar = 1;
    for iIn = 1:nNumeric
        u = uNumeric{iIn};
        s.origTypes{iIn} = fixed.internal.type.extractNumericType(u);
        [s,idxScalar] = processNumericInput(s,idxScalar,u);
    end
    s.Attrib = groupNumAttrib(s.Attrib); % finalize
    
    s.vOvercoat = castAllToType(s.Attrib.overcoatType,uNumeric,nTot);
    s.vOvercoat = fixed.internal.type.tightFi(s.vOvercoat);
    s.Attrib.overcoatType = numerictype(s.vOvercoat);
    s.Attrib.minPow2Wt = s.Attrib.overcoatType.FixedExponent;

    if s.opt.InType
        overcoat2 = s.Attrib.overcoatType;
        for iIn = 1:nNumeric
            overcoat2 = dtPairToOvercoat(overcoat2,s.origTypes{iIn});
        end
        s.Attrib.overcoatType = overcoat2;
        fe = s.Attrib.overcoatType.FixedExponent;
        wl = s.Attrib.overcoatType.WordLength;
        s.Attrib.minPow2Wt = fe;
        s.Attrib.maxPow2Wt = wl - 1 + fe;
        s.vOvercoat = castAllToType(s.Attrib.overcoatType,uNumeric,nTot);
    end        
     
    s = getDispAttrib(s);
    
    if s.Attrib.anyNegative
        fprintf('\nNegative values present: Two''s Complement Encoding shown\n');
    else
        fprintf('\nAll values non-negative: Unsigned Encoding shown\n');
    end

    if s.dispAttrib.usePedantic
        s = dispPedanticHeader(s);
    end
        
    for i=1:nTot
        dispScalar(s,i);
    end
end


function y = castAllToType(overcoatType,uNumeric,nTot)
    y = fi(zeros(nTot,1),overcoatType);
    idxScalar = 1;
    nNumeric = numel(uNumeric);
    for iIn = 1:nNumeric
        u = uNumeric{iIn};
        n = numel(u);
        for j=1:n
            y(idxScalar) = u(j);
            idxScalar = idxScalar + 1;
        end
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
    rwvStr = compactButAccurateDecStr(v.tfi);
    if isPosInNegGroup(s,v)
        rwvStr = [' ',rwvStr];
    end
end


function dispScalarBinPt(s,v)
    % binary point diplay of scalar
    %    get integer and fraction bits
    %    
    assert(s.dispAttrib.useTrueBinPtDisp);
    
    [intBits,fracBits] = getIntFracBitsForDisp(s,v);
    
    fmt = sprintf('  %%%ds.%%-%ds  =  %%s\n',...
        s.dispAttrib.binPtMaxPow2Wt+1,-s.dispAttrib.binPtMinPow2Wt);
    
    rwvStr = fmtRWV(s,v);
    
    fprintf(fmt,intBits,fracBits,rwvStr);
end


function dispScalarIntMantExp(s,v)
    % binary point diplay of scalar
    %    get integer and fraction bits
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);

    n1 = s.Attrib.maxBitSpan;
    n2 = s.dispAttrib.expWidth;

    fmtZ= sprintf('  %%%ds     %%-%ds  =  %%s\n',n1,n2);
    fmt = sprintf('  %%%ds * 2^%%-%dd  =  %%s\n',n1,n2);

    rwvStr = fmtRWV(s,v);

    if v.isZero
        fprintf(fmtZ,'0','',rwvStr);
    else
        sBin = v.tfi.bin;
        fe = v.FixedExponent;
        if isPosInNegGroup(s,v)
            sBin = ['0',sBin];
        end
        fprintf(fmt,sBin,fe,rwvStr);
    end
end


function dispScalarPedantic(s,v)
    % Pedantic binary display of scalar
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);
    assert(s.dispAttrib.usePedantic);
    

    uOver = fi(v.tfi,s.Attrib.overcoatType);
    bits = uOver.bin;

    for i = 1:s.pedantic.nCols
        printCenter(bits(i),s.pedantic.fullColWidth);
    end
    
    rwvStr = fmtRWV(s,v);
    
    fprintf('  =  %s\n',rwvStr);

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
    
    fprintf(' ')
    totWidth = min(80,nCols * s.pedantic.fullColWidth);
    printCenter('Bit Column Weights',totWidth);
    fprintf('\n')
    
    colFmt = sprintf(' %%%ds ',maxLengthLabels);
%     nNotBit = maxLengthLabels + 2 - 1;
%     nAfter = ceil(nNotBit/2);
%     bBefore = nNotBit - nAfter;
%     bitFmt = sprintf('%s%%s%s',repmat(' ',1,bBefore),repmat(' ',1,nAfter));
    
    delx = repmat('-',1,maxLengthLabels);
    
    rowDelx(nCols,colFmt,delx);
    for i = 1:nCols
        %fprintf(colFmt,colPow2Labels{i});
        printCenter(colPow2Labels{i},s.pedantic.fullColWidth);
    end
    fprintf('    Real World Value\n')
    for i = 1:nCols
        printCenter(colDecLabels{i},s.pedantic.fullColWidth);
    end
    fprintf('\n')
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
    v = s.v(i);
    
    if isfinite(v.tfi)        
        if s.dispAttrib.useTrueBinPtDisp
            dispScalarBinPt(s,v);
        elseif s.dispAttrib.usePedantic
            dispScalarPedantic(s,v);
        else
            dispScalarIntMantExp(s,v);
        end
    else
        fprintf('  %s\n',mat2str(double(v.tfi)));
    end
end


