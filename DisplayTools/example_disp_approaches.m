clc

inputs = {
    0
    3.125
    0.25
    2^-6
    2^6
    inf
    nan
    -inf
    };
showAllDisp('doubles',inputs{:})
[tcInput,v] = cTight(inputs);
showAllDisp('tight individual',tcInput{:})
showAllDisp('tight vector',v)

manyZeros = {
    fi(0,1,8,12)
    fi(0,0,5,9)
    0
    };
showAllDisp('manyZeros',manyZeros{:})


manyZeros2 = {
    fi(0,1,8,-12)
    fi(0,0,5,-19)
    0
    };
showAllDisp('manyZeros2',manyZeros2{:})



inputs = {
    -3.125
    0.25
    2.5
    };
showAllDisp('doubles',inputs{:})

inputs = single([
    3*2^10
    5*2^-12
    ]);
showAllDisp('doubles',inputs{:})


function [c,v] = cTight(c)
    n = numel(c);
    v = zeros(n,1);
    for i=1:n
        v(i) = double(c{i});
        if isfinite(c{i})
            c{i} = tightFiScalarCached(c{i});
        end
    end
    v = v(isfinite(v));
    v = fixed.internal.type.tightFi(v);
end    

