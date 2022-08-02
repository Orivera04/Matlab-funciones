function [n,s,u]= nfactors(m)
% MODEL/NFACTORS number of dependents for model
% 
%   n = nfactors(n)
% 
% Additional outputs are available
%   [n,symbols,units]= nfactors(m); 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:52:38 $

s= m.Xinfo.Symbols;
n= length(s);
if nargout>1
   u= m.Xinfo.Units;
end

   