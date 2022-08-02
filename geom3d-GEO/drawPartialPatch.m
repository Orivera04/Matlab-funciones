function drawPartialPatch(u, v, z, varargin)
%drawSurfPatch : draw surface patch, with 2 parametrized surfaces
%
%   usage :
%   drawSurfPatch(u, v, zuv)
%   where u, v, and zuv are three matrices the same size, u and
%   corresponding to each parameter, and zuv being equal to a function of u
%   and v.
%
%   drawSurfPatch(u, v, zuv, p0)
%   If p0 is specified, two lines with u(p0(1)) and v(p0(2)) are drawn on
%   the surface, and corresponding tangent are also shown.
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 24/05/2005.
%

%   HISTORY
%   08/06/2005 : add doc.
%   04/01/2007: remove unused variables and change function name

hold on;
surf(u, v, z, 'FaceColor', 'g', 'EdgeColor', 'none');
drawCurve3d(u(1,:), v(1,:), z(1,:))
drawCurve3d(u(end,:), v(end,:), z(end,:))
drawCurve3d(u(:,end), v(:,end), z(:,end))
drawCurve3d(u(:,1), v(:,1), z(:,1))

if length(varargin)>0
    pos = varargin{1};
    drawCurve3d(u(pos(1),:), v(pos(1),:), z(pos(1),:));
    drawCurve3d(u(:,pos(2)), v(:,pos(2)), z(:,pos(2)));
end    