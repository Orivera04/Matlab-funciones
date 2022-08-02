function Val = getFitOpt(m,Prop)
%GETFITOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:57 $

if nargin==1;
    Val = m.FitAlgorithm;
else
    if strcmpi(Prop,'name')
        Val = getname(m.FitAlgorithm);
    else
        Val = get(m.FitAlgorithm,Prop);
    end
end
