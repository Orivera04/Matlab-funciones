function s = size(P);
% cgOpPoint / size	

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:19 $
rows = get(P,'numpoints');
cols = get(P,'numfactors');
if nargout == 1
	s = [rows cols];
else
	s = rows;
end
