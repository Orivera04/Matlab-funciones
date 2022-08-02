function out=partialset(obj,ind)
% PARTIALSET  Return the partial list of candidate points
%
%   LIST=PARTIALSET(OBJ,IND) returns the partial list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:26 $

% Created 30/12/2000

npgrid= npoints(obj.grid);
nf= nfactors(obj);
out= zeros(length(ind),nf);

gr= (ind<=npgrid);
grind= ind(gr);

if any(gr)
   out(gr,:)= partialset(obj.grid,grind);
end
if any(~gr)
   out(~gr,:)=repmat(centerpoint(obj.candidateset),length(ind)-sum(gr),1);
end
return