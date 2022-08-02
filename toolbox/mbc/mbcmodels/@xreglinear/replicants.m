function [reps, smallx]=replicants(m,x,tol)
%xreglinear/REPLICANTS   Replicated design entries
%   reps=replicants(m,x) returns a cell array with each cell containing
%   a unique bio-engineered lifeform.  See also BLADERUNNERS for information
%   on deleting the above safely.
%
%   Note that these replicants have been likened to vectors containing a list
%   of test rows from x which are considered to be identical.  However this
%   similarity is purely coincidental.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:50:04 $


if nargin==2
   tol=0.005;
end

i=1;
n=1;
reps={};
indx=[1:size(x,1)];
while n<size(x,1)
   % Take nth row
   comprow=x(n,:);
   inds=[];
   % Scuttle down rest of x-matrix with it looking for replication
   for m=n+1:size(x,1)
      if abs(x(m,:)-comprow)<tol
         inds=[inds,m];
      end
   end
   if ~isempty(inds)
      % replication found
      % Save them to cell array
      reps{i}=[n, indx(inds)];
      % remove any replicated rows found to shorten later search
      x(inds,:)=[];
      indx(inds)=[];
      i=i+1;
   end
   n=n+1;
end

if nargout>1
   smallx=x;
end
