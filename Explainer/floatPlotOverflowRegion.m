function floatPlotOverflowRegion(attribOrNameValOrTotalBits, expBits, rangeOfInterest)


    % Copyright 2019-2023 The MathWorks, Inc.

    if nargin < 3
        rangeOfInterest = [];
    end

    if isstruct(attribOrNameValOrTotalBits)
        attrib = attribOrNameValOrTotalBits;
    elseif nargin < 2
        attrib = fixed.internal.type.attribFloatingPoint(attribOrNameValOrTotalBits);
    else
        attrib = fixed.internal.type.attribFloatingPoint(attribOrNameValOrTotalBits, expBits);
    end

    dRealmax = double(attrib.realmax);
    dRealmin = double(attrib.realmin);
    dTiny = double(attrib.tiny);

    xl = [dTiny dRealmax];

    xxOver = [1;        dRealmax; dRealmax; 1];
    yyOver = [dRealmax; 1;        dRealmax; dRealmax];

    xxDenormalIn = [dTiny; dTiny;    dRealmin; dRealmin; dRealmax; dRealmax; dTiny];
    yyDenormalIn = [dTiny; dRealmax; dRealmax; dRealmin; dRealmin; dTiny;    dTiny];


    yd = dRealmin/dTiny;
    xxDenorm = [dTiny;     yd; dTiny; dTiny];
    yyDenorm = [yd;     dTiny; dTiny; yd];

    xxZero = [dTiny;     1; dTiny; dTiny];
    yyZero = [1;     dTiny; dTiny; 1];

    hold off
    h = fill(xxOver,yyOver,'r');
    h.Parent.XScale = 'log';
    h.Parent.YScale = 'log';    
    hold on
    fill(xxDenormalIn,yyDenormalIn,'c')   
    fill(xxDenorm,yyDenorm,'y')
    fill(xxZero,yyZero,'m')
    loglog(dRealmax*[1],xl(1),'w.')
    x7 = [dRealmin, dRealmin, xl(2)];
    y7 = [xl(2),    dRealmin, dRealmin];    
    loglog(x7,y7,'k-')
    loglog(dTiny*[1],xl(1),'w.')

    cLeg = {'Overflow to Inf'
        'Denormal input'
        'Denormal result'
        'Underflow to Zero'
        sprintf('Realmax %s',mat2str(dRealmax,7))
        sprintf('Realmin %s',mat2str(dRealmin,7))
        sprintf('eps(0)  %s',mat2str(dTiny,7))
        };

    if ~isempty(rangeOfInterest)

        rangeOfInterest = double(rangeOfInterest(:));
        zl = min(dRealmax,max(rangeOfInterest));
        zh = max(dTiny,min(rangeOfInterest));        
        xdi = [zl, zl, zh, zh, zl ];
        ydi = [zl, zh, zh, zl, zl ];
        loglog(xdi,ydi,'b--');

        cLeg{end+1} = 'Domain of interest';
    end



    hold off
    xlabel('Input 1')
    ylabel('Input 2')
    title(sprintf('Homogeneous Floating Point Multiplication for %s',strrep(attrib.canonicalName,'_','')))
    grid on
    xlim(xl);
    ylim(xl);
    lgd = legend( cLeg,'location','east');


    ll = log10(xl);

    e2 = ll(2) + 0.01*diff(ll);

    xt = 10^e2;

    text(xt,dRealmax,'Realmax')
    text(xt,dRealmin,'Realmin')
    text(xt,dTiny,'eps(0)')

    th = text(dRealmax,xt,'Realmax','Rotation',90);
    th = text(dRealmin,xt,'Realmin','Rotation',90);
    th = text(dTiny,xt,'eps(0)','Rotation',90);


    shg
end
