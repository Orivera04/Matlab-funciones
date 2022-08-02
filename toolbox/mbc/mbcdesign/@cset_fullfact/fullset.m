function out=fullset(obj)
% FULLSET  Return the full list of candidate points
%
%   LIST=FULLSET(OBJ) returns the full list of points in the
%   candidate set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:21 $

% Created 30/12/2000

% do full factorial grid
out=fullset(obj.grid);

% add center points
if obj.Nc
   out(end+1:end+obj.Nc,:)=repmat(centerpoint(obj.candidateset),obj.Nc,1);
end
return