function out=partialset(obj,ind)
% PARTIALSET  Return the partial list of candidate points
%
%   LIST=PARTIALSET(OBJ,IND) returns the partial list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:37 $

% Created 1/11/2000

if ~isempty(ind)
   if ~isa(ind,'double')
      ind= double(ind);
   end
   g=length(obj.griddims);
   l=length(obj.lattdims);
   if g==0
      out=partialset(obj.lattice,ind);
   elseif l==0
      out=partialset(obj.grid,ind);
   else
      % create lattice points
      N=get(obj.lattice,'N');
      out=zeros(length(ind),(l+g));
      out(:,obj.lattdims)=partialset(obj.lattice,(rem(ind-1,N)+1));
      % create grid points
      out(:,obj.griddims)=partialset(obj.grid,ceil(ind./N));
   end
else
   cand=[];
end

return