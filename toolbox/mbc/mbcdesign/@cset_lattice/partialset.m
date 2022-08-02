function out=partialset(obj,ind)
% PARTIALSET  Return the partial list of candidate points
%
%   LIST=PARTIALSET(OBJ,IND) returns the partial list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:05 $

% Created 1/11/2000

if ~isempty(ind)
   out=zeros(length(ind),length(obj.g));
   if ~isa(ind,'double')
      ind= double(ind);
   end
   lims=limits(obj.candidateset);
   for i=1:length(obj.g)
      out(:,i)=rem(obj.g(i).*(ind(:)-1),obj.N);
   end
   lowpnt=repmat(lims(:,1)',length(ind),1);
   scaling=repmat((diff(lims,1,2)')./(obj.N-1),length(ind),1);
   out=lowpnt+out.*scaling;
else
   out=[];
end
return