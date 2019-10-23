function s = showAbsRelDiff(vExpect,vActual,doShow)
    %showAbsRelDiff collect information and form strings for
    % showing the absolute and relative differences between 
    % two values.
    %
    % Optionally, the strings are immediately displayed to 
    % the Command Window. Default is yes, display.

    % Copyright 2019 The MathWorks, Inc.

    if ~exist('doShow','var')
        doShow = true;
    end
    
    s.absDiff = '';
    s.relDiff = '';

    if isfinite(vExpect) && isfinite(vActual) && ( (vExpect~=0) || (vActual~=0) )

        vExpect = standardizeInputs(vExpect);
        vActual = fixed.internal.math.castFiToMATLAB(vActual);

        if isfloat(vExpect)
            epsExpect = double( eps(vExpect) );            
        else
            vTemp = fi(vExpect(1));
            epsExpect = double( eps(vTemp) );
        end

        
        
        if isfloat(vExpect) && isfloat(vActual)
            absDiff = double(vExpect) - double(vActual);
        else
            vExpect = makeBinPt(vExpect);
            vActual = makeBinPt(vActual);
            if vExpect >= vActual
                absDiff = vExpect - vActual;
            else
                absDiff = vActual - vExpect;
            end
        end

        s.absDiff = sprintf('absDiff = %s',mat2str(absDiff,5));
        
        if 0 ~= absDiff
            n = round( 4 * double(absDiff) / double(epsExpect) ) / 4;
            if 1 == n
                strN = '';
            else
                strN = [mat2str(n,5),'*'];
            end
            s.absDiff = sprintf('%s = %seps(yExpect)',s.absDiff,strN);
        end
        
        if 0 ~= vExpect && 0 ~= absDiff
            
            relDiff = double(absDiff) ./ abs(double(vExpect));
            
            [ff,ee]=log2(relDiff);
            ff = 2*ff;
            ee = ee - 1;
            ff = round(100*ff);
            if ff == 200
                ff = 1;
                ee = ee + 1;
            else
                ff = ff / 100;
            end
            
            
            s.relDiff = sprintf('relDiff = %s = ',mat2str(relDiff,5));
            if ff ~= 1
                strFF = mat2str(ff,5);
                s.relDiff = sprintf('%s%s*',s.relDiff,strFF);
            end
             s.relDiff = sprintf('%s2^%d',s.relDiff,ee);            
        end
        if doShow
            fprintf('   %s',s.absDiff);
            if ~isempty(s.relDiff)
                fprintf('   %s',s.relDiff);
            end
        end
    end
end

function y = standardizeInputs(u)
    y = fixed.internal.math.castFiToMATLAB(u);
    y = fixed.internal.math.castIntToFi(y); 
end


function y = makeBinPt(u)
    y = fixed.internal.type.tightFi(u,2^16);
    y = fixed.internal.math.fullSlopeBiasToBinPt(y);
end
