function [v0,v1,v2] = showMulExtremes(nt1,nt2,doPrune)
   
    if ~exist('doPrune','var')
        doPrune = false;
    end
    
    sv1 = getTypeInterestingValues(nt1);
    n1 = numel(sv1);
    
    sv2 = getTypeInterestingValues(nt2);
    n2 = numel(sv2);
    
    n = n1*n2;
    
    v1 = repmat( sv1(1), n, 1);
    v2 = repmat( sv2(1), n, 1);
    v0 = repmat( sv1(1).*sv2(1), n, 1);
    
    ii = (1:n2);
    for i1 = 1:n1
        jj = ((i1-1)*n2) + ii;
        curV1 = sv1(i1);
        v1(jj) = curV1;
        v2(jj) = sv2;
        v0(jj) = curV1 .* sv2;
    end

    [v0,ii]=sort(v0);
    v1 = v1(ii);
    v2 = v2(ii);
    
    iiDrop = [false; v0(1:(end-1)) == v0(2:end)];
    
    ix = find(iiDrop);
    v0(ix) = [];
    v1(ix) = [];
    v2(ix) = [];
    
    if doPrune
        [v0,v1,v2] = valPrune(v0,v1,v2);
    end
end

function [v0,v1,v2] = valPrune(v0,v1,v2)

    % This function assumes v0 is already sorted
    
    [v0,v1,v2] = doDrop(v0,v1,v2,v0 < 0);
    [v0,v1,v2] = doDrop(v0,v1,v2,v0 > 0);
end
    
function [v0,v1,v2] = doDrop(v0,v1,v2,iiDrop)
    
    if sum(iiDrop) > 4       
        idxDrop = find(iiDrop);
        idxDrop(1:2) = [];
        idxDrop(end-(0:1)) = [];
        v0(idxDrop) = [];
        v1(idxDrop) = [];
        v2(idxDrop) = [];
    end    
end
