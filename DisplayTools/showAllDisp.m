function showAllDisp(label,varargin)
    hr = repmat('-',40);
    fprintf('%s\n%s\n%s\n',hr,label,hr);

    fprintf(' dispBinPedanticMin\n')
    dispBinPedanticMin(varargin{:})
    
    fprintf(' dispBinPedanticExtend\n')
    dispBinPedanticExtend(varargin{:});
    
    fprintf(' dispBinPedanticInType\n')
    dispBinPedanticInType(varargin{:})
    
    fprintf(' dispBinPt\n')
    dispBinPt(varargin{:})
     
    fprintf('\n\n dispBinIntMantExp\n')
    dispBinIntMantExp(varargin{:})
     
    fprintf('\n\n dispBinIntMantExpAlign\n')
    dispBinIntMantExpAlign(varargin{:})

    fprintf('\n\n dispBinIntMantExpAlignInType\n')
    dispBinIntMantExpAlignInType(varargin{:})    
end
