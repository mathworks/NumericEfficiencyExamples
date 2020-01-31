function acbSaveFig(iFig,sFilename)
    %acbSaveFig utility for saving figures for publishing very specific
    % to the Shoulder Zone work
    
    % Copyright 2019-2020 The MathWorks, Inc.
    
    figure(iFig);
    figureHandle = gcf;
    set(figureHandle, 'Color', 'white'); % white bckgr
    
    set(figureHandle, 'Unit','pixels');
    x = 1000;
    y = round(1.25*x);
    pos = [-x 0 x y];
    set(figureHandle,'position',pos);     % set size
    
    saveas(figureHandle,sFilename,'jpg')
end
