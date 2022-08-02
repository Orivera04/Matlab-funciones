function Val = getFitOpt(m,Prop)
%GETFITOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:07 $

if nargin==1
	Val= m.om;
else
	if strcmpi(Prop,'name')
		Val= getname(m.om);
    else
	    Val= get(m.om,Prop);
    end
end
