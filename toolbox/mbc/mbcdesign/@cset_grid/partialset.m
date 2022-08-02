function out=partialset(obj,ind)
% PARTIALSET  Return the partial list of candidate points
%
%   LIST=PARTIALSET(OBJ,IND) returns the partial list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:07 $

% Created 1/11/2000

if ~isempty(ind)
   % number of points in each dimension
   s=cellfun('length',obj.levels);
   s=s(:)';
   
   % initialise cand
   out=zeros(length(ind),length(obj.levels));
   
   ind2=ind2sub(s,ind);
   for n=1:length(s)
      x= obj.levels{n}(:);
      out(:,n)=x(ind2(length(s)-n+1,:));
   end
else
   out=[];
end

return