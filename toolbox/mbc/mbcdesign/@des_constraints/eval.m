function [c,in]= eval(c,X,st,keep_pts);
%EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:01:48 $

if nargin<4
   keep_pts=1;
end
if nargin<3
   st=0;
end

if ~isempty(X)
   in = true(size(X,1),1);
   
   for n=1:length(c.Constraints)
      in=constrain(c.Constraints{n},X,in);
   end
   
   if keep_pts
      % keep track of interior points
      c.InteriorPoints= [c.InteriorPoints 
         uint32(st+find(in))];
   end
else
   in=[];
end
