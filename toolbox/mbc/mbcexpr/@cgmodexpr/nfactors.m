function [n,s,u] = nfactors(mod)
%NFACTORS number of dependents for model
% 
%    n = nfactors(n)
% 
%  Additional outputs are available
%    [n,symbols,units]= nfactors(m); 
%
%  Returns 0 if the cgmodexpr is empty

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:21 $

m = mod.model;
if ~isempty(m)
	% Returns the number, symbols and units of the factors in the model M
	[n,s,u]=nfactors(m);
    u = reshape(u,length(u),1);
else
	n=0;s='';u='';
end