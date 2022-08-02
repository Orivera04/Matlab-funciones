function out = tri_surf(LT,X,Y,Z,TRI,x,y)
%TRI_SURF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:32 $

% X and Y give the coordinates of a series of points in the plane and TRI is the corresponding
% Delaunay triangularisation. Z is a set of corresponding z-values, and (x,y) are the coordinates of a
% point in the plane. This function aims to provide a z- value to go with (x,y) so the the resulting point 
% will be on the surface 'through' the data set (X,Y,Z). First we find the triangles that (x,y) belongs to,
% if none then set the value to 0, otherwise send it through the tricompute function fro each triangle it's in,
% this will compute the z-value that would put the point (x,y,z) on the plane of the triangle. 
% We then average these values.

W = tsearch(X,Y,TRI,x,y);

if isnan(W)
   out = 0;
else
   sum = 0;
   for i = 1:length(W)
       T = TRI(W(i),:);   
       sum = sum+tricompute(LT, [X(T(1));Y(T(1));Z(T(1))],[X(T(2));Y(T(2));Z(T(2))],[X(T(3));Y(T(3));Z(T(3))],x,y);
   end
   out = sum/i;
end

if isnan(out)
   out = 0;
end

