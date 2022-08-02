function varargout = drawSphericalTriangle(sphere, p1, p2, p3)
%DRAWSPHERICALTRIANGLE draw a triangle on a sphere
%
%   DRAWSPHERICALTRIANGLE(SPHERE, PTA, PT2, PT3)
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 22/02/2005
%

%   HISTORY


p1 = normalize3d(p1);
p2 = normalize3d(p2);
p3 = normalize3d(p3);

r = sphere(4);

plane = createPlane(p1, p1);
pp2 = planePosition(intersectPlaneLine(plane, [0 0 0 p2]), plane);
pp3 = planePosition(intersectPlaneLine(plane, [0 0 0 p3]), plane);

s = 0:.25:1;
t = 0:.25:1;
ns = length(s);
nt = length(t);
s = repmat(s, [nt, 1]);
t = repmat(t', [1, ns]);


xp = s*pp2(1) + t.*(1-s)*pp3(1);
yp = s*pp2(2) + t.*(1-s)*pp3(2);
x = plane(1)*ones(size(xp)) + plane(4)*xp + plane(7)*yp;
y = plane(2)*ones(size(xp)) + plane(5)*xp + plane(8)*yp;
z = plane(3)*ones(size(xp)) + plane(6)*xp + plane(9)*yp;


norm = sqrt(x.*x + y.*y + z.*z);
xn = x./norm*r;
yn = y./norm*r;
zn = z./norm*r;


if nargout == 0
    surf(xn, yn, zn, 'FaceColor', 'g', 'EdgeColor', 'none');
else
    varargout{1} = x;
    varargout{2} = y;
    varargout{3} = z;
end
