function [info,dispStr] = utilGetCoderTargetInfo(curSys)
    % utilGetCoderTargetInfo get information about a models code gen target(s)
        
    % Copyright 2019-2020 The MathWorks, Inc.

    myConfigObj = getActiveConfigSet(curSys);
    h=get(myConfigObj,'Components');
    
    info.Production = getTargInfo(h,'Prod');

    if info.Production.isMicro
        info.UseDivisionForNetSlopeComputation = get(h(3),'UseDivisionForNetSlopeComputation');
        info.Production.have64 = any(64 == info.Production.wordLengths);
    end
    
    info.cgProduction = strcmp('on',get(h(5),'ProdEqTarget'));
    
    if ~info.cgProduction
        info.TestingTarget = getTargInfo(h,'Target');
    end
        
    if info.cgProduction
        dispStr = sprintf('C Code Gen for Production\n');
    else
        dispStr = sprintf('ALERT: C Code Gen for\nNon Production Testing Target\n');
    end
        
    dispStr = appendTargInfo(dispStr,info.Production,'Production');        
    if ~info.cgProduction
        dispStr = appendTargInfo(dispStr,info.TestingTarget,'Testing');
    end    
end


function dispStr = appendTargInfo(dispStr,targInfo,targetCatStr)
    
    dispStr = sprintf('%s\n%s Target:\n %s\n',dispStr,...
        targetCatStr,targInfo.HWDeviceType);
    
    if targInfo.isMicro
        dispStr = sprintf('%sChar: %d  ',dispStr,targInfo.BitPerChar);
        dispStr = sprintf('%sShot: %d\n',dispStr,targInfo.BitPerShort);
        dispStr = sprintf('%sInt: %d  ',dispStr,targInfo.BitPerInt);
        dispStr = sprintf('%sLong: %d\n',dispStr,targInfo.BitPerLong);
        dispStr = sprintf('%sLongLong: %d\n',dispStr,targInfo.BitPerLongLong);
    end    
end
    
    

function info = getTargInfo(h,base)
    
    info.HWDeviceType = get(h(5),[base,'HWDeviceType']);
    
    fpga = 'ASIC/FPGA';
    info.isMicro = isempty(strfind(info.HWDeviceType,fpga));
    
    if ~info.isMicro
        return
    end
    
    suffix = {
        'BitPerChar'
        'BitPerShort'
        'BitPerInt'
        'BitPerLong'
        'BitPerLongLong'
        'BitPerFloat'
        'BitPerDouble'
        'BitPerPointer'
        'BitPerSizeT'
        'BitPerPtrDiffT'
        'LargestAtomicInteger'
        'LargestAtomicFloat'
        'IntDivRoundTo'
        'Endianess'
        'WordSize'
        'ShiftRightIntArith'
        'LongLongMode'
        };
    
    for i=1:numel(suffix)
        fn = suffix{i};
        try
            info.(fn) = get(h(5),[base,fn]);
        catch
        end
    end
    
    try
        v = info.LongLongMode;
        if ~strcmp(v,'on')
            info.BitPerLongLong = 0;
        end
    catch
    end
    try
        suffix2 = {
            'BitPerChar'
            'BitPerShort'
            'BitPerInt'
            'BitPerLong'
            'BitPerLongLong'
            };
        
        info.wordLengths = [];
        for i=1:numel(suffix2)
            fn = suffix2{i};
            try
                v = info.(fn);
                if v > 0
                    info.wordLengths(end+1) = v;
                end
            catch
            end
        end
        info.wordLengths = unique(info.wordLengths);
    catch
    end
end