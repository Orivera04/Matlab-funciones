function m=reorderX(m,ord)
% REORDERX   Reorder model input factors
%
%   M=REORDERX(M,ORD) reorders the model input factors in M 
%   according to the indices in ORD.  ORD must have the
%   same number of unique indices as there are input factors in 
%   M or an error will occur
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:56 $

% Created 11/12/2000

% Check ord
nf=nfactors(m);
ord(ord<1)=[];
ord(ord>nf)=[];

ord2=unique(ord(:))';
if length(ord2)~=nf
   error('Invalid reordering specified.');
end

% reorder
m.code=m.code(ord);
m.Xinfo.Names=m.Xinfo.Names(ord);
m.Xinfo.Units=m.Xinfo.Units(ord);
m.Xinfo.Symbols=m.Xinfo.Symbols(ord);
return
