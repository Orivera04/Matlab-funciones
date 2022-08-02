function n=name(L);
% LOCALMOD/NAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:27 $

n= class(L);
if length(n)>5 & strcmp(n(1:5),'local')
	n= n(5+1:end);
end