function showDifferences(vExpect,vActual,opt,varargin)
    % show detailed differences between two arrays
    %
    % Examples of details
    %   includes showing differences of zero and negative zero.

    % Copyright 2019 The MathWorks, Inc.

    if isempty(opt)
        opt.sOut1 = '';
        opt.sOut2 = '';
    end
    if ~isfield(opt,'sIn')
        opt.sIn = {};
    end
    nIn = numel(varargin);
    uLabelLen = 0;
    for i=1:nIn
        if length(opt.sIn) < i
            opt.sIn{i} = sprintf('Input%d',i);
        end
        uLabelLen = max(uLabelLen,length(opt.sIn{i}));
    end
    opt.sInMaxLen = uLabelLen;
        
    sIdx = getIndices(vExpect,vActual);
    
    z = false;
    %
    idxIgnore = ignoreObviousMatches(sIdx);
    
    showIgnore(idxIgnore)
    
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'Nan','Inf',idxIgnore, ...
        sIdx.idxNanA, sIdx.idxInfB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'Inf','Nan',idxIgnore, ...
        sIdx.idxInfA, sIdx.idxNanB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'Nan','Finite',idxIgnore, ...
        sIdx.idxNanA, ~sIdx.idxNanB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'Finite','Nan',idxIgnore, ...
        ~sIdx.idxNanA, sIdx.idxNanB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)

    [idxIgnore,z] = showCategoricalPair(z,opt,1,'+Inf','-Inf',idxIgnore, ...
        sIdx.idxPosInfA, sIdx.idxNegInfB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'-Inf','+Inf',idxIgnore, ...
        sIdx.idxNegInfA, sIdx.idxPosInfB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'+Inf','Finite',idxIgnore, ...
        sIdx.idxPosInfA, sIdx.idxFiniteB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'Finite','+Inf',idxIgnore, ...
        sIdx.idxFiniteA, sIdx.idxPosInfB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)

    [idxIgnore,z] = showCategoricalPair(z,opt,1,'-Inf','Finite',idxIgnore, ...
        sIdx.idxNegInfA, sIdx.idxFiniteB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'Finite','-Inf',idxIgnore, ...
        sIdx.idxFiniteA, sIdx.idxNegInfB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)

    [idxIgnore,z] = showCategoricalPair(z,opt,1,'+Zero','-Zero',idxIgnore, ...
        sIdx.idxPosZeroA, sIdx.idxNegZeroB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,1,'-Zero','+Zero',idxIgnore, ...
        sIdx.idxNegZeroA, sIdx.idxPosZeroB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    
    [idxIgnore,z] = showCategoricalPair(z,opt,2,'Zero','Non-Zero',idxIgnore, ...
        sIdx.idxZeroA, ~sIdx.idxZeroB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    [idxIgnore,z] = showCategoricalPair(z,opt,2,'Non-Zero','Zero',idxIgnore, ...
        ~sIdx.idxZeroA, sIdx.idxZeroB, vExpect, vActual, varargin{:});
    showIgnore(idxIgnore)
    
    z = showFiniteMismatch(z,opt,idxIgnore, sIdx, vExpect, vActual, varargin{:});
    
    if ~z
        fprintf('Everything matches exactly\n');
    end
end

function showIgnore(idxIgnore) %#ok<INUSD>
%    fprintf('*** Ignore %d   Left %d\n',sum(idxIgnore),sum(~idxIgnore));
end



function s = getValStr(u)
    
    if isfloat(u)
        w = double(u);
        if 0 == w
            v = fi(w,numerictype('double'));
            s = v.Value;
        else
            s = fixed.internal.compactButAccurateNum2Str(w);
        end
    elseif isfi(u)
        s = u.Value;
    else
        v = fixed.internal.type.tightFi(u);
        s = v.Value;
    end
end



function misMatchShown = showFiniteMismatch(misMatchShown,opt,idxIgnore, sIdx, vExpect, vActual, varargin)
        
    idxMismatched = (~idxIgnore) & ...
        (sIdx.idxFiniteA & sIdx.idxFiniteB) & ( vExpect ~= vActual );
    
    misMatchShown = showMismatches(misMatchShown,opt,4,'Finite cases',idxMismatched,vExpect, vActual, varargin{:});
end


function sIdx = getIndices(vExpect,vActual)
    
    sIdx = struct();
    sIdx = getOneIndices(sIdx,vExpect,'A');
    sIdx = getOneIndices(sIdx,vActual,'B');
end

function sIdx = getOneIndices(sIdx,u,sChar)
    
    idxPos = u > 0;
    idxNeg = u < 0;
    idxFinite = isfinite(u);
    idxInf = isinf(u);
    idxPosInf = idxPos & idxInf;
    idxNegInf = idxNeg & idxInf;
    idxNan = isnan(u);
    idxZero = u == 0;
    idxPosZero = idxZero;
    idxNegZero = false(size(u));
    if isfloat(u)
        recipZero = (1./u(idxZero));
        idxPosZero(idxZero) = recipZero > 0;
        idxNegZero(idxZero) = recipZero < 0;
    end
    
    sIdx.(['idxPos',sChar]) = idxPos;
    sIdx.(['idxNeg',sChar]) = idxNeg;
    sIdx.(['idxFinite',sChar]) = idxFinite;
    sIdx.(['idxInf',sChar]) = idxInf;
    sIdx.(['idxPosInf',sChar]) = idxPosInf;
    sIdx.(['idxNegInf',sChar]) = idxNegInf;
    sIdx.(['idxNan',sChar]) = idxNan;
    sIdx.(['idxZero',sChar]) = idxZero;
    sIdx.(['idxPosZero',sChar]) = idxPosZero;
    sIdx.(['idxNegZero',sChar]) = idxNegZero;
end


function idxIgnore = ignoreObviousMatches(sIdx)
    
    idxIgnore = ...
        (sIdx.idxPosZeroA & sIdx.idxPosZeroB) | ...
        (sIdx.idxNegZeroA & sIdx.idxNegZeroB) | ...
        (sIdx.idxPosInfA & sIdx.idxPosInfB) | ...
        (sIdx.idxNegInfA & sIdx.idxNegInfB) | ...
        (sIdx.idxNanA & sIdx.idxNanB);
end



function [idxIgnore,misMatchShown] = showCategoricalPair(misMatchShown,opt,n,sTitle1, sTitle2 ,idxIgnore, iia, iib, vExpect, vActual, varargin)
        
    idxPair = (~idxIgnore) & (iia & iib);
    idxIgnore = idxIgnore | idxPair;
    sTitleX = [sTitle1,' vs ',sTitle2];
    misMatchShown = showMismatches(misMatchShown, opt,n,sTitleX, idxPair, vExpect, vActual, varargin{:});
end



function misMatchShown = showMismatches(misMatchShown,opt,nMax,sTitle,idxMismatch,vExpect, vActual, varargin)
    
    if any(idxMismatch)

        nMismatch = sum(idxMismatch(:));
        nMax = min(nMax,nMismatch);

        showExampleCount = nMax > 1 || nMismatch > 1;
        
        a2 = vExpect(idxMismatch);
        b2 = vActual(idxMismatch);
        nt = fixed.internal.type.extractNumericType(a2);
        if isfixed(nt) && nt.WordLength > 51
            fiNegOne = fi(-1,1,2,0);
            absDiff = a2 + fiNegOne * b2;
            ii3 = a2 < b2;
            absDiff(ii3) = -absDiff(ii3);
            absDiff = double(absDiff);
        else
            absDiff = abs( double(vExpect(idxMismatch)) - double(vActual(idxMismatch)) );
        end
        [~,iiSort]=sort(absDiff,'descend');
        
        for j = 1:nMax
        
            misMatchShown = true;
            
            k = iiSort(j);
            
            fprintf('Mismatch outputs: %s\n',sTitle)            
            if showExampleCount
                fprintf(' Ex. %d of %d observed.\n',j,nMismatch);
            end
            
            temp = vExpect(idxMismatch);
            aTemp = temp(k);
            aS = getValStr(aTemp);
            temp = vActual(idxMismatch);
            bTemp = temp(k);
            bS = getValStr(bTemp);

            
            nIn = numel(varargin);
            
            maxLen1 = max(length(opt.sOut1),length(opt.sOut2));
            maxLen2 = max(length(aS),length(bS));
            fmt  = sprintf('  %%7s: %%-%ds = %%-%ds   %%s\\n',maxLen1,maxLen2);
            sDiff = showAbsRelDiff(aTemp,bTemp,false);
            
            fprintf(fmt, 'yExpect', opt.sOut1, aS, sDiff.absDiff);
            fprintf(fmt, 'yActual', opt.sOut2, bS, sDiff.relDiff);
            
            for i = 1:nIn
                if 1 == i
                    fprintf('    Input(s)\n')
                    fmt2 = sprintf('      %%-%ds = %%s\\n',opt.sInMaxLen);
                end
                u = varargin{i};
                szu = size(u);
                nNonScalar = sum(szu > 1);
                if nNonScalar > 1
                    s2e1 = ['u(',repmat(':,',1,numel(szu)-1),'idxMismatch);'];
                    temp = eval(s2e1);
                    s2e2 = ['temp(',repmat(':,',1,numel(szu)-1),'k);'];
                    uVal = eval(s2e2);
                    suVal = mat2str(uVal,18,'class');
                else
                    temp = u(idxMismatch);
                    suVal = getValStr(temp(k));
                end
                sULabel = opt.sIn{i};
                fprintf(fmt2, sULabel, suVal);
            end
        end
    end
end
