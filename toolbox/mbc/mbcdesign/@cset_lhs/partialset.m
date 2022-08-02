function out=partialset(obj,ind)
% PARTIALSET  Return the partial list of candidate points
%
%   LIST=PARTIALSET(OBJ,IND) returns the partial list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:47 $

% Created 2/11/2000


if ~isempty(ind)
   s.type='()';
   s.subs={1,':'};
   out = zeros(length(ind),nfactors(obj));
   out = repmat(subsref(limits(obj)',s),length(ind),1)+ ...
      repmat(obj.delta,length(ind),1).*(double(obj.indices(ind,:))-1);
else
   out=[];
end

return