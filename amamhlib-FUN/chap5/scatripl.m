function v=scatripl(ax,ay,az,bx,by,bz,cx,cy,cz)
%
% v=scatripl(ax,ay,az,bx,by,bz,cx,cy,cz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Scalar triple product dot(cross(a,b),c) where
% the cartesian components of vectors a,b,and c
% are given in arrays of the same size.
v=ax.*(by.*cz-bz.*cy)+ay.*(bz.*cx-bx.*cz)...
  +az.*(bx.*cy-by.*cx);