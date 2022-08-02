function out = tri_restrict(LT, X,Y,TRI)
%TRI_RESTRICT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:31 $

% Removes degenerate triangles (you know, ones that smoke,take drugs or have no area) from the delaunay triangularisation
% TRI of X and Y.

idx = ones(length(TRI),1);

for i = 1:length(TRI);
   x = X(TRI(i,:))';
   y = Y(TRI(i,:))';
   if sum(cross(x,y))==0
      idx(i) = 0;
   end
end
out = TRI(idx(:)==1,:);
