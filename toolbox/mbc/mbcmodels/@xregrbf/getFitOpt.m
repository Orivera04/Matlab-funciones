function Val= getFitOpt(m,Prop)
% RBF/GETFITOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:54:43 $

if nargin==1;
	Val= m.om;
else
	if strcmp(lower(Prop),'name')
		Val= getname(m.om);
    else
	    Val= get(m.om,Prop);
    end
end
