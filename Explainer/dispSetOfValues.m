function dispSetOfValues(varargin)

    % Copyright 2019-2023 The MathWorks, Inc.

    if ~exist('dispBinPtPreferInType','file')
        try
            mpath = fileparts(mfilename('fullpath'));
            mpath = [mpath,filesep,'..',filesep,'DisplayTools'];
            addpath(mpath)
        catch
        end
    end

    if ~exist('getMatlabCoderLibConfig','file')
        try
            mpath = fileparts(mfilename('fullpath'));
            mpath = [mpath,filesep,'..',filesep,'Tools'];
            addpath(mpath)
        catch
        end
    end

    if exist('dispBinPtPreferInType','file')

        doSlopeBias = false;
        for ik=1:numel(varargin)
            ntx = fixed.extractNumericType(varargin{ik});
            if ntx.isslopebiasscaled
                doSlopeBias = true;
                break
            end
        end
        if doSlopeBias
            dispScalingEqInType(varargin{:});
        else
            dispBinPtPreferInType(varargin{:});
        end
    else
        for i=1:nargin
            uCur = varargin{i};
            dispValuesLocal(uCur);
        end
    end
end

function dispValuesLocal(u)
    assert(isnumeric(u))
    u = castFiToMATLAB(u);
    u = castIntToFi(u);
    for i=1:numel(u)
        uCur = u(i);
        if isfi(uCur)
            fprintf('(SI) %s bin ',uCur.bin)
            if u.SlopeAdjustmentFactor ~= 1
                fprintf('* %s ',num2str(u.Slope,17))
            elseif u.FixedExponent ~= 0
                fprintf('* 2^%d ',u.FixedExponent );
            end
            if u.Bias ~= 0
                fprintf('+ %s ',num2str(u.Bias,17))
            end
            fprintf(' = %s\n',uCur.Value);
        else
            fprintf('%s\n',mat2str(uCur,'class',17))
        end
    end
end
        

