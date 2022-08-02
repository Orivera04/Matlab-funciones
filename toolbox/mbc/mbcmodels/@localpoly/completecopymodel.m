function L=completecopymodel(L);
% LOCALPOLY/COMPLETECOPYMODEL 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:18 $

if DatumType(L) & ~is121(L);
	% turn off coding for local pspline
	[Bnds,g,Tgt]= getcode(L);
	Tgt(:,2)= Inf;
	L= setcode(L,Bnds,g,Tgt);
	TS.Local= L;
end