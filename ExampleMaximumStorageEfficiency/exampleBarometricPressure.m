clc
hi = 1084; % millibar
lo =  870; % millibar
nBitsCompact = 8;
nBitsBinPt = 18;

% lo = 11
% hi = 11 + 7
span = hi - lo;
nBitsCompact = 8;
qHi = 2^nBitsCompact - 1;
qLo = 0;
idealSlope = span / 2^nBitsCompact;
idealBias = lo + idealSlope/2;
ntIdeal = numerictype(0,nBitsCompact,idealSlope,idealBias);
showScale('Ideal Min Error Per Bit',ntIdeal);
plotErrors(1,lo,hi,ntIdeal);

[nt2,ntBinPt] = bestQuantNT(lo,hi,ntIdeal,nBitsBinPt);

showScale('Nice Convert Scaling',nt2);
plotErrors(2,lo,hi,ntIdeal,nt2);

showScale('BinPt Scaling',ntBinPt);

sQ = nt2.Slope/ntBinPt.Slope;
bQ = nt2.Bias/ntBinPt.Slope;
ntFake = nt2;
ntFake.Slope = sQ;
ntFake.Bias = bQ;
showScale('Integer Equation',ntFake);
binPtIntRange = sQ*[qLo,qHi]+bQ
log2(binPtIntRange)

function showScale(label,nt)
    slope = nt.Slope;
    bias = nt.Bias;
    tS = fixed.internal.type.tightFi(slope);
    tB = fixed.internal.type.tightFi(bias);
    fprintf('%s\n',label)
    fprintf('V = %s * Q + %s     %s\n',tS.Value,tB.Value,nt.tostring)
end


function plotErrors(iFig,lo,hi,nt,nt2)
    [maxAbsErr,absErr,vIdeal] = computeError(lo,hi,nt);
    figure(iFig);
    plot(vIdeal,absErr,'r-');
    if exist('nt2','var')
        [maxAbsErr2,absErr2,vIdeal2] = computeError(lo,hi,nt2);
        hold on
        plot(vIdeal2,absErr2,'b-');
        hold off
    end
    xlabel('Ideal In')
    ylabel('Abs Error')
    axis tight
    grid on
    shg
end

function [maxAbsErr,absErr,vIdeal,vQuant] = computeError(lo,hi,nt)
    vIdeal = linspace(lo,hi,2^18+1);
    vQuant = fi(vIdeal,nt);
    absErr = abs(double(vQuant) - (vIdeal));
    maxAbsErr = max(absErr(:));
end

function [nt2,ntBinPt] = bestQuantNT(lo,hi,ntIdeal,nBitsBinPt)

    q = stripscaling(fi([lo hi],ntIdeal));
    tS = fixed.internal.type.tightFi(ntIdeal.Slope);
    tB = fixed.internal.type.tightFi(ntIdeal.Bias);
    
    y = (tS*q)+tB;
    nty = numerictype(y);
    
    if nty.WordLength <= nBitsBinPt
        ntBinPt = nty;
        nt2 = ntIdeal;
        return
    end
    
    nBitsCompact = ntIdeal.WordLength;
    qHi = 2^nBitsCompact - 1;
    qLo = 0;

    idealSlope = ntIdeal.Slope;
    idealBias = ntIdeal.Bias;
    hi1 = idealSlope * qHi + idealBias;
    lo1 = idealSlope * qLo + idealBias;
    hiLo1 = [hi1 lo1];
    isNeg = any(hiLo1 < 0,'all');
    
    fiHiLo1 = fi( hiLo1, isNeg, nBitsBinPt);
    
    ntBinPt = numerictype(fiHiLo1);

    fmCeil = fimath('RoundingMethod', 'Ceiling', ...
        'OverflowAction', 'Saturate');
    fmFloor = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Saturate');
    
    biasHi = double(fi(idealBias,ntBinPt,fmCeil)); 
    biasLo = double(fi(idealBias,ntBinPt,fmFloor)); 
    
    ntSlope = ntBinPt;
    ntSlope.WordLength = nBitsBinPt - nBitsCompact;
    slopeHi = double(fi(idealSlope,ntSlope,fmCeil));
    slopeLo = double(fi(idealSlope,ntSlope,fmFloor));
    
    nt2 = [];
    maxAbsErr2 = inf;
    for b = [biasHi, biasLo]
        for s = [slopeHi, slopeLo]
            ntX = numerictype(0,nBitsCompact,s,b);
            maxAbsErrX = computeError(lo,hi,ntX);
            if maxAbsErrX < maxAbsErr2
                maxAbsErr2 = maxAbsErrX;
                nt2 = ntX;
            end
        end
    end
end
