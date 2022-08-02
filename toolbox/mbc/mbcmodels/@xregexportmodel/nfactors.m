function [n,s,u]=nfactors(M);
%NFACTORS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:36 $

% EXPORTMODEL/NFACTORS number of dependents for model
% 
%   n = nfactors(n)
% 
% Additional outputs are available
%   [n,symbols,units]= nfactors(m); 

% Returns the number, symbols and units of the factors in the model M
n = length(M.symbols);
if nargout>1
    s = M.symbols;
    if isempty(M.units)
        u = [];
    else
        u = M.units(2:end);
        u = reshape(u,length(u),1);
    end
end
