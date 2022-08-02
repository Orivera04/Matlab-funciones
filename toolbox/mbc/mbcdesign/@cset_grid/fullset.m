function out=fullset(obj)
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:02 $

% Created 1/11/2000

if length(obj.levels)>1
   % Generate N-D grid for evaluation
   [X{1:length(obj.levels)}]=ndgrid(obj.levels{:});
else
   X=obj.levels(1);
end
% Change into NxNg table 
out= zeros(prod(size(X{1})),length(X));
for i=1:length(X)
   out(:,i)= X{i}(:);
end
return
