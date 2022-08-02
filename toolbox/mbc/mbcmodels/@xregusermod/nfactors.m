function [nf,s,u]= nfactors(U);
%XREGUSERMOD/NFACTORS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:31 $

nf= feval(U.funcName,U,'nfactors');
if isempty(nf)
    nf= nfactors(U.xregmodel);
end

if nargout>1
    xi= xinfo(U);
    s= xi.Symbols;
    u= xi.Units;
end