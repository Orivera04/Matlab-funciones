function [CGFMCG, CGFMCFAC, JP, THRESH] = pgetGlobals(sumst, type)
% GETGLOBALS 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:38 $

gradglob = sumst.gradglob;

switch type
    case 'objective'
        CGFMCG = gradglob.objective{1};
        CGFMCFAC = gradglob.objective{2};
        JP = gradglob.objective{3};
        THRESH = gradglob.objective{4};
    case 'constraint'
        CGFMCG = gradglob.constraint{1};
        CGFMCFAC = gradglob.constraint{2};
        JP = gradglob.constraint{3};
        THRESH = gradglob.constraint{4};
end
