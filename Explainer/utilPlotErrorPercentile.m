function utilPlotErrorPercentile(errRounding,nty)

    % Copyright 2019-2023 The MathWorks, Inc.

    nErr = numel(errRounding);
    if nErr <= 0
        return
    end
    absErrRounding = sort(abs(errRounding));
    errRounding = sort(errRounding);
    h = figure();
    xPercentitle = linspace(0.5/nErr,1,nErr);
    plot(xPercentitle,errRounding,'.-',xPercentitle,absErrRounding,'.-');
    xlabel('Percentile')
    ylabel('Error')
    title('Error Percentile Plots')
    ave = mean(errRounding);
    absAve = mean(absErrRounding);
    legend({
        sprintf('Error,     mean = %.3f  (%.3f bits)',ave,ave/nty.Slope)
        sprintf('Abs Error, mean = %.3f  (%.3f bits)',absAve,absAve/nty.Slope)
        },'Location','southeast')
    axis tight
    grid on
    yl = ylim;
    
    halfSlope = nty.Slope/2;

    ylx = yl;
    ylx(1) = min(ylx(1),0);
    ylx(1) = floor(ylx(1)/halfSlope)*halfSlope;
    ylx(2) = ceil(ylx(2)/halfSlope)*halfSlope;
    if any(ylx ~= yl)
        ylim(ylx);
    end
    yl2 = (ylx)/nty.Slope;
    yyaxis right
    ylim(yl2)
    ylabel('Bits of Error')
    yyaxis left
    xy = h.Position;
    xy(3:4) = [700, 500];
    h.Position = xy;
end
