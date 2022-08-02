function [ind,rfcond]=SelectRF(ps);
% localpspline/SELECTRF determines possible combinations or response features for reconstruction
%
% [ind,rfcond]=SelectRF(ps);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:57 $

% all combinations calculated in LOCALMOD/SELECTRF
[ind,rfcond]= SelectRF(ps.localmod,size(ps,1));

% the knot rf must be included 
DispList= get(ps,'feat.disp');
KnotFeat= strmatch('Knot',DispList,'exact');
if length(KnotFeat)==1
   Knotrf= any(ind==KnotFeat,2);
   ind= ind(Knotrf,:);
   rfcond= rfcond(Knotrf);
end