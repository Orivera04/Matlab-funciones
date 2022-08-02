function centalg = getCentalg(m)
%GETCENTALG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:54:42 $

om = getFitOpt(m);
% algorithm to delve into the xregoptmgr and pick out the center selection algorithm
try
    centalg = getFitOpt(m,'CenterSelectionAlg');
catch
    try
        alg = getFitOpt(m,'NestedFitAlgorithm');
        if strcmp(lower(getname(alg)),'stepitrols')
            centalg = alg; % nested alg is its own center selection alg
        else
            centalg = get(alg,'CenterSelectionAlg');
        end
    catch
        try
            alg = getFitOpt(m,'NestedFitAlgorithm');
            alg2 = get(alg,'NestedFitAlgorithm');
            if strcmpi(getname(alg2),'stepitrols')
                centalg = alg2; % nested alg is its own center selection alg
            else
                centalg = get(alg2,'CenterSelectionAlg');
            end
        catch
            centalg = om;
        end
    end
end