function b = allBinPtCompatible(varargin)
    %allBinPtCompatible determine if all input VALUES can be displayed
    % in binary point WITHOUT padding bits on left or right
    %
 
    % Copyright 2022 The MathWorks, Inc.

    b = true;

    for i=1:nargin
        v = varargin{i};
        nt = fixed.extractNumericType(v);
        
        if any(~isfinite(v)) || ...
                ~fixed.internal.type.isTrivialSlopeAdjustBias(nt)
            b = false;
            return
        end

        if nt.isfloat
            a = fixed.internal.type.attribFloatingPoint(nt);
            nMant = a.mantissaBitsEffective;
            wl = 2*nMant+1;
            vf1 = fi(v,1,wl,nMant);
            vf2 = fi(v,1,nMant+1);
            if any(vf1 ~= vf2)
                b = false;
                return
            end
        else
            if  ( nt.FixedExponent > 0 ) || ...
                    (0 > (nt.WordLength + nt.FixedExponent))
                b = false;
                return
            end
        end
    end
end
