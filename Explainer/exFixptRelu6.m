function r = exFixptRelu6(a,b,c,d) %#codegen


    % Copyright 2019-2023 The MathWorks, Inc.

    r.y1 = relu6_nta(a);
    r.y2 = relu6_ntb(b);
    r.y3 = relu6_ntc(c);
    r.y4 = relu6_ntd(d);
end

function y = relu6_nta(u)
    coder.inline('never')
    y = min( 6, max( 0, u ));
end

function y = relu6_ntb(u)
    coder.inline('never')
    y = min( 6, max( 0, u ));
end

function y = relu6_ntc(u)
    coder.inline('never')
    y = min( 6, max( 0, u ));
end

function y = relu6_ntd(u)
    coder.inline('never')
    y = min( 6, max( 0, u ));
end
