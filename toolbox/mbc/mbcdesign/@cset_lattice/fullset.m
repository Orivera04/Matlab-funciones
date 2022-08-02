function out=fullset(obj);
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:01 $

% Created 1/11/2000

out= zeros(obj.N,length(obj.g));
lims=limits(obj.candidateset);
for i=1:length(obj.g)
   out(:,i)=rem(obj.g(i).*(0:(obj.N-1))',obj.N);
end
lowpnt=repmat(lims(:,1)',obj.N,1);
scaling=repmat((diff(lims,1,2)')./(obj.N-1),obj.N,1);
out=lowpnt+out.*scaling;
return
