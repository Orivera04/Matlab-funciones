function s=size(S,dim);
% SWEEPSET/SIZE size of sweepset (nrec , nvar , nsweeps)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:11:35 $



s= [S.nrec,S.nvar,size(S.xregdataset)];
if nargin==2
   s=s(dim);
end
