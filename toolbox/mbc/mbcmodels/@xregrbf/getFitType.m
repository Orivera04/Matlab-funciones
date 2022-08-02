function qr= GetFitType(m);
%GETFITTYPE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:44 $

qr = i_FindType(getFitOpt(m));

function qr= i_FindType(om);

name= lower(getname(om));
switch name
    case {'trialwidths','uga'}
        qr= i_FindType(get(om,'NestedFitAlg'));
    case 'uga2'
        qr= i_FindType(get(om,'CenterSelectionAlg'));
    case {'rederr','iterateridge','multilevel'}
        qr= 'ridge';
    case {'iteraterols','stepitrols'}
        qr= 'rols';
    case 'ccga'
        qr= 'ols';
    case 'rols'
        qr = 'rols';
    case 'rederr'
        qr = 'ridge';
    case 'wigglecenters'
        qr = 'ridge';
    otherwise
        error('Cannot determine FitType');
end
