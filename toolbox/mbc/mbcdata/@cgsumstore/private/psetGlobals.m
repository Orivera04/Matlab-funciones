function sumst = psetGlobals(sumst, type, CGFMCG, CGFMCFAC, JP, THRESH)
% SETGLOBALS 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:39 $

gradglob = sumst.gradglob;

switch type
    case 'objective'
        gradglob.objective{1} = CGFMCG;
        gradglob.objective{2} = CGFMCFAC;
        gradglob.objective{3} = JP;
        gradglob.objective{4} = THRESH;
    case 'constraint'
        gradglob.constraint{1} = CGFMCG;
        gradglob.constraint{2} = CGFMCFAC;
        gradglob.constraint{3} = JP;
        gradglob.constraint{4} = THRESH;
end

sumst.gradglob = gradglob;