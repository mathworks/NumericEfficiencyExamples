function [info,dispStr] = utilGetCoderTargetInfo(curSys)
    
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
        
    %dispStr = sprintf('Double Click to Change\nHardware Parameters\n');
    
    if info.cgProduction
        dispStr = sprintf('Code Gen for Production\n\n');
    else
        dispStr = sprintf('ALERT: Code Gen for\nNon Production Testing Target\n\n');
    end
        
%     if info.Production.have64
%         have64Str = 'Native 64 bits available';
%         patchColor = [0 1 0]; % green
%     else
%         have64Str = 'WARNING: 64 bits NOT available';
%         patchColor = [1 0 0]; % red
%     end

    dispStr = sprintf('%sProduction Target:\n %s\n',dispStr,info.Production.HWDeviceType);
    dispStr = appendTargInfo(dispStr,info.Production);    
    %dispStr = sprintf('%sUse Division %s\n',dispStr,info.UseDivisionForNetSlopeComputation);
    
    if ~info.cgProduction
        dispStr = sprintf('%Testing Target: %s\n',dispStr,info.TestingTarget.HWDeviceType);
        dispStr = appendTargInfo(dispStr,info.TestingTarget);
    end    
end


function dispStr = appendTargInfo(dispStr,targInfo)
    
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
    
    info.isMicro = ~strcmp(info.HWDeviceType,'ASIC/FPGA');
    
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