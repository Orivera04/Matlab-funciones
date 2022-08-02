function out = getranges(M)
%GETRANGES  Return the model input ranges
%
%  R = getranges(M) reutrns a 2 x n double matrix [low1 low2 ...;high1
%  high2 ...]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:12 $

if ~isempty(M.model)
	out = getranges(M.model);
else
	n = nfactors(M);
	out = repmat([-inf;inf],1,n);
end