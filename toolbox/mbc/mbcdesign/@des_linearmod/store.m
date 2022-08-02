function s= store(smod,s);
%STORE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:46 $

if nargin==1
	s= smod.store;
else
	smod.store= s;
	s= smod;
end