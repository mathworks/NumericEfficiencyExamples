function y = compReducingSumGoldenBaseline(u)
    %compReducingSumGoldenBaseline compute the full precision value
    % of integer reducing sum. The reduction is done over all
    % dimensions except the last one.
    %
    % Conceptually the same as 
    %      y(i) = sum(u(:,:,i))
    % except all chance of overflow are prevented
    % so the full precision output is returned.
    
    % Copyright 2019 The MathWorks, Inc.
    
    sz = size(u);
    nLast = sz(end);
    className = fullPrecisionSumReduceType(u(:,:,1));
    y = repmat(zeros(1,1,className),nLast,1);
    for i=1:nLast
        u = u(:,:,i);
        u2 = cast(u,className);
        y(i) = sum(u2,'all');
    end
end
