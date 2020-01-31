function appendRightBitsAxis(slope,bias,textLabel)
    % appendRightBitsAxis append a dual scale axis to the right of a plot
    %
    % Note: axis will ALWAYS be set to left on return
    %    
    % This should only be called after you are 100% done with plotting
    % items against the left axis.
    % If you do ANYTHING that causes the 4-tuple returned by axis
    % on the left axis to change, then the second axis will 
    % NOT be in agreement with the left axis.
    %    
    % Typically this is done for showing error in bit or in eps
    %
    % The coefficients of the affine equation that maps the left axis
    % to the right axis must be supplied. 
    %    vLeft = Slope * vRight + Bias
    % slope must be given
    % bias will default to zero
    %
    % textLabel defaults to 'Bits'
    %
    
    % Copyright 2019-2020 The MathWorks, Inc.

    if nargin < 3
        textLabel = 'Bits';
    end
    if nargin < 2
        bias = 0;
    end
    
    yyaxis left
    xyLeft = axis;            
    
    yyaxis right
    xyRight = (xyLeft - [0 0 bias bias]) ./ [1 1 slope slope];
    axis(xyRight);
    ylabel(textLabel)

    yyaxis left
end
