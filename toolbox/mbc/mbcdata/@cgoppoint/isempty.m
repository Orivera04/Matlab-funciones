function out = isempty(P)
%ISEMPTY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:52:05 $

out = (get(P,'numfactors') == 0);
	