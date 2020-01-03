function runMeFirst_HiddenGenCodeGenTestingTarget(openItems)
    %runMeFirst_HiddenGenCodeGenTestingTarget setup for example in this folder 
    %
    % To easily run the example in this folder and below, this function
    % will do the following.
    % 1) Modify the path to make needed resources available.
    % 2) Open a few items such as models, libraries or files to make
    %    the starting point of interaction easier to find.
            
    % Copyright 2019-2020 The MathWorks, Inc.

    if ~exist('openItems','var')
        openItems = true;
    end
        
    fullPath = mfilename('fullpath');
    folderPath = fileparts(fullPath);
    addpath(folderPath)

    addpath([folderPath,filesep,'..',filesep,'MoreEfficientCodeInTwoClicks']);
    runMeFirst_MoreEfficientCodeInTwoClicks(false);
    
    olderThanR2019b = verLessThan('matlab','9.7');
    if olderThanR2019b
        modelFolder = 'R2015a';
    else
        modelFolder = 'R2019b';
    end
    addpath([folderPath,filesep,modelFolder]);
    
    if openItems
        mdls = {
            'model_for_FPGA_w_C_testing_target'
            'modelCodeGenTargetInfoLib'
            };
        for i=1:numel(mdls)
            open_system(mdls{i});
        end
    end
end

