function out=fullset(obj);
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:42 $

% Created 2/11/2000

if ~isempty(obj.indices)
   out= zeros(obj.N,nfactors(obj));
   struc.type='()';
   struc.subs={1,':'};
   out = repmat(subsref(limits(obj)',struc),obj.N,1)+ ...
      repmat(obj.delta,obj.N,1).*(double(obj.indices)-1);
else
   out=[];
end
return
