function out=npoints(obj)
% NPOINTS  Return the number of points in a candidate set
%
%  NP=NPOINTS(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:36 $

% Created 1/11/2000

% multiply out grid
out=npoints(obj.grid);
if out==0
   if length(obj.lattdims)
      out=1;   
      out=out.*get(obj.lattice,'n');
   end
else   
   if length(obj.lattdims)
      out=out.*get(obj.lattice,'n');
   end 
end

return