function dispVarious(varargin)
    %dispVarious display input values in various formats
    
    % Copyright 2019-2020 The MathWorks, Inc.

    objX = numericDispUtil.groupNumericAttrib2(varargin{:});
    s.Attrib = objX;
    s.opt = objX.opt;
    s.vals = objX.vals;    
    s = getDispAttrib(s);
    
    % Get maximum chars for real world value
    %
    s = determineNumCharsForRWV(s);
    
    if s.Attrib.anyNonFinite
        sFin = ' finite';
    else
        sFin = '';
    end
    
    if s.Attrib.anyNegative
        fprintf('\nNegative%s values present: Two''s Complement Encoding shown\n\n',sFin);
    else
        fprintf('\nAll%s values non-negative: Unsigned Encoding shown\n\n',sFin);
    end

    if s.dispAttrib.usePedantic
        s = dispPedanticHeader(s);
    else
        % ToDo fix bug here not always binary point display
        %
        s = dispBinHeader(s);
    end
        
    for i=1:s.Attrib.nTot
        dispScalar(s,i);
    end
end


function s = determineNumCharsForRWV(s)
    ncRWV = 10;
    for i = 1:numel(s.vals)
        rwvStr = fmtRWV(s.vals(i));
        ncRWV = max(ncRWV,length(rwvStr));
    end
    s.dispAttrib.nCharsRWV = ncRWV;
end


function rwvStr = fmtRWV(v)
    % get formated real world value
    %        
    if isempty(v.minBitSpanBinPt)
        x = v.origValue;
    else
        x = v.minBitSpanBinPt;
    end
    rwvStr = compactButAccurateDecStr(x);
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
    
    printRWV(s,1,fmtRWV(v));
    fprintf(fmt,intBits,fracBits);
end


function dispScalarIntMantExp(s,v,align)
    % binary point diplay of scalar
    %    get integer and fraction bits
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);

    if align
        maxFe = s.Attrib.maxPow2Wt;
        minFe = s.Attrib.minPow2Wt;
        n1 = maxFe - minFe + 1;
    else
        n1 = s.Attrib.maxBitSpan;
    end
    n2 = s.dispAttrib.expWidth;

    fmtZ= sprintf('%%%ds     %%-%ds\n',...
        n1,n2);
    fmt = sprintf('%%%ds * 2^%%-%dd\n',...
        n1,n2);

    printRWV(s,1,fmtRWV(v));

    curVal = getValBasedOnOption(s,v);    
    
    useType = s.opt.InType;        
    if ~useType && v.isZero
        fprintf(fmtZ,'0',''); %#ok<CTPCT>
    else
        sBin = curVal.bin;
        fe = curVal.FixedExponent;
        if align
            minFe = s.Attrib.minPow2Wt;
            nRightPad = fe - minFe;
            sBin = [sBin,repmat(' ',1,nRightPad)];
        end
        fprintf(fmt,sBin,fe);
    end
end


function dispScalarPedantic(s,v)
    % Pedantic binary display of scalar
    %    
    assert(~s.dispAttrib.useTrueBinPtDisp);
    assert(s.dispAttrib.usePedantic);
    
    extendRangeGiveSpaces = ~s.opt.extendRange;
    extendPrecisionGiveSpaces = ~s.opt.extendPrecision;
    
    curVal = getValBasedOnOption(s,v);
    
    bits = numericDispUtil.getBitOverPow2Range(curVal,...
        s.Attrib.minPow2Wt,...
        s.Attrib.maxPow2Wt,...
        extendRangeGiveSpaces,extendPrecisionGiveSpaces);

%     uOver = fi(v.minBitSpanBinPt,s.Attrib.typeOvercoatOfAllMinBitSpans);
%     bits = uOver.bin;

    printRWV(s,1,fmtRWV(v));
    
    for i = 1:s.pedantic.nCols
        numericDispUtil.printCenter(bits(i),s.pedantic.fullColWidth);
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
    nMaxRow2 = getMaxCharsFor2ndRowValue(p2Hi,p2Lo);
    
    for i=1:nCols
        p2 = p2Vec(i);
        curLabel = sprintf('2^%d',p2);
        vRow2 = 2^p2;
        if isfinite(vRow2) && vRow2 ~= 0
            curLabel2 = mat2str(2^p2,19);
        else
            curLabel2 = '';
        end
        curLabel2 = removeLeadZero(curLabel2);
        
        %         if p2 == p2Hi && s.Attrib.anyNegative
        %             curLabel = ['-',curLabel]; %#ok<AGROW>
        %             curLabel2 = ['-',curLabel2]; %#ok<AGROW>
        %         end
        curLen = length(curLabel);
        curLen2 = length(curLabel2);
        if curLen2 > nMaxRow2
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
    numericDispUtil.printCenter('Weighted Bit Columns',totWidth);
    fprintf('\n')
    
    colFmt = sprintf(' %%%ds ',maxLengthLabels);
    
    printRWV(s,0,'');
    delx = repmat('-',1,maxLengthLabels);
    
    rowDelx(nCols,colFmt,delx);

    printRWV(s,0,'Real World');
    for i = 1:nCols
        numericDispUtil.printCenter(colPow2Labels{i},s.pedantic.fullColWidth);
    end
    fprintf('\n')

    printRWV(s,0,'Value');
    for i = 1:nCols
        numericDispUtil.printCenter(colDecLabels{i},s.pedantic.fullColWidth);
    end
    fprintf('\n')
    printRWV(s,0,'');
    rowDelx(nCols,colFmt,delx);

    s.pedantic.nCols = nCols;
    s.pedantic.colFmt = colFmt;
    %s.pedantic.bitFmt = bitFmt;
    s.pedantic.p2Vec = p2Vec;
end

function n = getMaxCharsFor2ndRowValue(p2Hi,p2Lo)

    n = 4;
    curLabel = sprintf('2^%d',p2Hi);
    n = max(n,length(curLabel));
    curLabel = sprintf('2^%d',p2Lo);
    n = max(n,length(curLabel));
end


function rowDelx(nCols,colFmt,delx)
    for i = 1:nCols
        fprintf(colFmt,delx);       
    end
    fprintf('\n');
end

function str = removeLeadZero(str)
    if length(str) >= 3 && str(1) == '0' && str(2) == '.'
        str(1) = [];
    end
end

function dispScalar(s,i)
    v = s.vals(i);
    
    if isfinite(v.minBitSpanBinPt)        
        if s.dispAttrib.useTrueBinPtDisp
            dispScalarBinPt(s,v);
        elseif s.dispAttrib.usePedantic
            dispScalarPedantic(s,v);
        else            
            dispScalarIntMantExp(s,v, s.dispAttrib.doAlign);
        end
    else
        %fprintf('  %s\n',mat2str(double(v.minBitSpanBinPt)));
        printRWV(s,0,mat2str(double(v.origValue)));
        fprintf('\n');
    end
end

function printRWV(s,useEqual,str)
    fprintf(' ');
    numericDispUtil.printCenter(str,s.dispAttrib.nCharsRWV);
    if useEqual
        fprintf(' = ');
    else
        fprintf('   ');
    end
end
