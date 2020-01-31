function showShoulderZone(dataTypeOut,dataTypeIn,opts)
    %showShoulderZone show the Shoulder Zones on data type conversion
    % analysis plots.
    %
    % The Shoulder Zone is region of the input domain that might overflow
    % or might not overflow depending on the rounding mode that is
    % selected.
    %
    % Usage:
    %    showShoulderZone(dataTypeOut)
    %
    % Example
    %    showShoulderZone( numerictype(1,3,1) )
    %
    % Requirements:
    %    Fixed-Point Designer
    %    R2019b or later
    %       might not work in earlier releases.
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    if ~exist('opts','var')
        opts = [];
    end
    if ~exist('dataTypeIn','var')
        dataTypeIn = [];
    elseif ~isempty(dataTypeIn)
        dataTypeIn = fixed.internal.type.extractNumericType(dataTypeIn);
    end
    
    
    dataTypeOut = fixed.internal.type.extractNumericType(dataTypeOut);
    validateType(dataTypeOut);
    
    r = getValues(dataTypeOut,dataTypeIn,opts);
    
    OverflowAction = {
        'Wrap'
        'Saturate'
        };
    RoundingMethod = {
        'Nearest'
        'Ceiling'
        'Zero'
        'Floor'
        };
    
    iFigure = 1;
    for ioa = 1:numel(OverflowAction)
        for irm = 1:numel(RoundingMethod)
            iFigure = doPlot(iFigure,dataTypeOut,dataTypeIn,r,...
                RoundingMethod{irm},OverflowAction{ioa},opts);
        end
    end
end

function iFigure = doPlot(iFigure,dataTypeOut,dataTypeIn,r,RoundingMethod, OverflowAction,opts)
    
    figure(iFigure)
    subplot(1,1,1)
    fullPlot(r,dataTypeOut,dataTypeIn,RoundingMethod, OverflowAction);
    shg
    if isfield(opts,'rootFigName')
        sss = sprintf('%s_%s%s%s',...
            opts.rootFigName,...
            dataTypeOut.tostringInternalSlName,...
            RoundingMethod, OverflowAction);
        acbSaveFig(iFigure,sss)
    end
    
    iFigure = iFigure + 1;
end


function fullPlot(r,dataTypeOut,dataTypeIn,RoundingMethod, OverflowAction)
    
    z = miniCalc(r.full,dataTypeOut,RoundingMethod, OverflowAction, 2^17+1,false);
    
    fullPlotHalf(true,r,dataTypeOut,dataTypeIn,z,RoundingMethod, OverflowAction);
    fullPlotHalf(false,r,dataTypeOut,dataTypeIn,z,RoundingMethod, OverflowAction);
end

function fullPlotHalf(doUpper,r,dataTypeOut,dataTypeIn,z,RoundingMethod, OverflowAction)
    
    if doUpper
        subplot(2,1,1)
        hold off
        plot(z.u,z.u,z.u,z.y);
    else
        subplot(2,1,2)
        hold off
        plot(z.u,z.err);
    end
    axis tight
    xyOrig = axis;
    slope = r.leftDelta;
    if ~doUpper
        k = 1.125*slope;
        xyOrig(3) = min(xyOrig(3),-k);
        xyOrig(4) = max(xyOrig(4), k);
    end
    vH = xyOrig(3:4);
    
    colorOverflow = [1 0 0];
    colorInRange  = [0 1 0];
    colorShoulder = [1 1 0];
    
    leg = {};
    leg = doFill(leg,'Certain Overflow Left',r.leftOverflow,vH,colorOverflow);
    leg = doFill(leg,'Certain Overflow Right',r.rghtOverflow,vH,colorOverflow);
    leg = doFill(leg,'Shoulder Zone Left',r.leftShoulder,vH,colorShoulder);
    leg = doFill(leg,'Shoulder Zone Right',r.rghtShoulder,vH,colorShoulder);
    leg = doFill(leg,'Certain In Range',r.inRange,vH,colorInRange);
    
    sModes = sprintf('    Round: %s    OverflowAction: %s',...
        RoundingMethod, OverflowAction);
    if ~isempty(dataTypeIn)
        sInDt = [dataTypeIn.tostring,' '];
    else
        sInDt = '';
    end
    sOutDt = sprintf('Output %s',dataTypeOut.tostring);
    
    if doUpper
        leg = plotLeg(leg,'Ideal Output',z.u,z.u,'k:',1.25);
        leg = plotLeg(leg,'Quantized Output',z.u,z.y,'k-',1.25);
        xlabel('Input')
        ylabel('Output')
        st = sprintf('Input %sQuantized to %s\n%s',...
            sInDt,sOutDt, sModes);
        title(st)
    else
        xBar = xyOrig(1:2);
        yBar = slope*[1 1];
        
        leg = plotLeg(leg,'Error',z.u,z.err,'k-',1.25);
        leg = plotLeg(leg,'1 Bit Threshold',xBar,yBar,'k--');
        %        if nSlopes < 7
        %            leg = plotLeg(leg,'1/2 Bit Threshold',xBar,0.5*yBar,'k-.');
        %        end
        leg = plotLeg(leg,'Zero Error Level',xBar,0*yBar,'k:');
        %        if nSlopes < 7
        %           leg = plotLeg(leg,'1/2 Bit Threshold',xBar,-0.5*yBar,'k-.');
        %        end
        leg = plotLeg(leg,'1 Bit Threshold',xBar,-yBar,'k--');
        
        xlabel('Input')
        ylabel('Error = Output - Input')
        title(sprintf('Quantization Error  %s\n%s',sOutDt,sModes));
    end
    %legend(leg,'Location','BestOutside')
    %legend(leg,'Location','Best')
    legend(leg,'Location','South')
    %grid on
    axis(xyOrig);
    hold off
    if doUpper
        appendRightBitsAxis(1,0,'Output');
    else
        appendRightBitsAxis(r.leftDelta);
    end
    
    if 1
        ax = gca;
        if 1
            if doUpper
                pos = [0 0.51 1 0.49];
            else
                pos = [0 0 1 0.49];
            end
            ax.OuterPosition = pos;
            %ax.TightInset = pos;
        end
        outerpos = ax.OuterPosition;
        
        ti = ax.TightInset;
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3);
        ax_height = outerpos(4) - ti(2) - ti(4);
        ax.Position = [left bottom ax_width ax_height];
    end
end


function leg = plotLeg(leg,str,x,y,marker,thicknessFactor)
    if ~isempty(x)
        if ~exist('doThick','var')
            thicknessFactor = 1;
        end
        leg{end+1} = str;
        if 1 ~= thicknessFactor
            %plot(x,y,marker,'MarkerSize',300);
            plot(x,y,marker,'LineWidth',thicknessFactor);
        else
            plot(x,y,marker);
        end
        hold on
    end
end


function leg = doFill(leg,str,vX,vY,c)
    
    if ~isempty(vX)
        leg{end+1} = str;
        
        x = vX([1 1 2 2 1]);
        y = vY([1 2 2 1 1]);
        fill(x,y,c);
        hold on
    end
end


function z = miniCalc(vRange,dataTypeOut,RoundingMethod, OverflowAction, nPts, removeEnds)
    
    if ~exist('nPts','var')
        nPts = 2^10+1;
    end
    if ~exist('removeEnds','var')
        removeEnds = true;
    end
    
    u = linspace(vRange(1),vRange(2),nPts);
    if removeEnds
        u([1 end]) = [];
    end
    
    yt = fixed.internal.math.castUniversal(u,dataTypeOut,[],...
        'RoundingMethod', RoundingMethod, 'OverflowAction', OverflowAction);
    
    y = double(yt);
    
    err = y - u;
    
    z.u = u;
    z.y = y;
    z.err = err;
end



function validateType(dataTypeOut)
    % Check that data type easily fits in double
    %
    sd = doubleShrunkExtremes();
    sn = getExtremes(dataTypeOut);
    if ( ...
            dataTypeOut.WordLength > 45 || ...
            sn.lo < sd.lo || ...
            sd.hi < sn.hi )
        
        error('The range or precision of the type is to high for this educational analysis.');
    end
end


function s = doubleShrunkExtremes()
    fHalf = fixed.internal.math.fiHalf();
    s.lo = fixed.internal.type.tightFi(-realmax)*fHalf;
    s.hi = fixed.internal.type.tightFi(realmax)*fHalf;
end

function s = getExtremes(dataTypeOut)
    s.lo = fixed.internal.type.minFiniteRepresentableVal(dataTypeOut);
    s.hi = fixed.internal.type.maxFiniteRepresentableVal(dataTypeOut);
end

function r = getValues(dataTypeOut,dataTypeIn,opts)
    
    s = getExtremes(dataTypeOut);
    
    loNext = fixed.internal.math.nextFiniteRepresentable(s.lo);
    hiPrev = fixed.internal.math.prevFiniteRepresentable(s.hi);
    
    dLo = double(s.lo);
    dHi = double(s.hi);
    
    dLoNext = double(loNext);
    dHiPrev = double(hiPrev);
    
    loDelta = dLoNext - dLo;
    hiDelta = dHi - dHiPrev;
    
    if isempty(opts) || ~isfield(opts,'nSteps')
        nSteps = 3;
    else
        nSteps = opts.nSteps;
    end
    
    r.full = [
        dLo + (loDelta * -nSteps)
        dHi + (hiDelta *  nSteps)
        ].';
    
    r.leftOverflow     = dLo + (loDelta * [-nSteps   -1  ]);
    r.leftLeftShoulder = dLo + (loDelta * [-1   -0.5]);
    r.leftShoulder     = dLo + (loDelta * [-1    0  ]);
    r.rghtLeftShoulder = dLo + (loDelta * [-0.5  0  ]);
    r.leftInRange      = dLo + (loDelta * [ 0    2  ]);
    
    r.inRange          = [dLo, dHi];
    
    r.rghtInRange      = dHi + (hiDelta * [-2    0  ]);
    r.rghtLeftShoulder = dHi + (hiDelta * [ 0    0.5]);
    r.rghtShoulder     = dHi + (hiDelta * [ 0    1  ]);
    r.rghtRghtShoulder = dHi + (hiDelta * [ 0.5  1  ]);
    r.rghtOverflow     = dHi + (hiDelta * [ 1    nSteps  ]);
    
    r = pruneToInputRange(r,dataTypeIn);
    
    r.leftDelta = loDelta;
    r.rghtDelta = hiDelta;
end


function r = pruneToInputRange(r,dataTypeIn)
    
    if isempty(dataTypeIn)
        return
    end
    
    s = getExtremes(dataTypeIn);
    
    dLo = double(s.lo);
    dHi = double(s.hi);
    
    fns = fieldnames(r);
    for i=1:numel(fns)
        fn = fns{i};
        v = r.(fn);
        
        if dHi <= v(1)
            v = [];
        elseif v(2) <= dLo
            v = [];
        else
            v(1) = max(v(1),dLo);
            v(2) = min(v(2),dHi);
        end
        r.(fn) = v;
    end
end
