function m = setCentalg(m,centalg)
%SETCENTALG routine to delve into the main xregoptmgr and set the center selection algorithm

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:57:19 $

om = getFitOpt(m);
try
    set(om,'CenterSelectionAlg',centalg);
catch
    try
        alg = get(om,'NestedFitAlgorithm');
        if strcmpi(getname(alg),'stepitrols')
            alg = centalg;
        else
            set(alg,'CenterSelectionAlg',centalg);
        end
        set(om,'NestedFitAlgorithm',alg);
    catch
        try
            alg = get(om,'NestedFitAlgorithm');
            alg2 = get(alg,'NestedFitAlgorithm');
            if strcmpi(getname(alg2),'stepitrols')
                alg2 = centalg;
            else
                set(alg2,'CenterSelectionAlg',centalg);
            end
            set(alg,'NestedFitAlgorithm',alg2);
            set(om,'NestedFitAlgorithm',alg);
        catch
            om = centalg;
        end
    end
end
setFitOpt(m,om);

