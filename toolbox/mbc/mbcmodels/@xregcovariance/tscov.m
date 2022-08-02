function [W,bnds]= tscov(c,W0,SF)
%TSCOV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:28 $

bnds=[];
G= unstruct(c);
if nargin==3
   G= SF*G*SF;
end
if isempty(G)
   W=[];
else
   W= blkdiag_add(W0,1,G);
end
