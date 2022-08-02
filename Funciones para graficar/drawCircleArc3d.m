function varargout = drawCircleArc3d(circle, varargin)
%DRAWCIRCLEARC3D draw a 3D circle arc
%
%   DRAWCIRCLE3D([XC YC ZC R PHI THETA PSI THETA1 THETA2])
%   [XC YC ZC]  : coordinate of circle center
%   R           : circle radius
%   [PHI THETA] : orientation of circle normal (theta : 0->pi).
%   PSI         : roll of circle (rotation of circle origin)
%   THETA1      : starting angle of arc
%   THETA2      : ending angle of arc
%   
%
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 21/02/2005
%

%   HISTORY


if iscell(circle)
    h = [];
    for i=1:length(circle)
        h = [h drawCircleArc3d(circle{i}, varargin{:})];
    end
    if nargout>0
        varargout{1}=h;
    end
    return;
end

if size(circle, 1)>1
    h = [];
    for i=1:size(circle, 1)
        h = [h drawCircleArc3d(circle(i,:), varargin{:})];
    end
    if nargout>0
        varargout{1}=h;
    end
    return;
end

% get center and radius
xc = circle(:,1);
yc = circle(:,2);
zc = circle(:,3);
r  = circle(:,4);

% get angle of normal
phi     = circle(:,5);
theta   = circle(:,6);
psi     = circle(:,7);

theta1  = circle(:,8);
theta2  = circle(:,9);



N = 64;
t = [0:2*pi/N:2*pi*(1-1/N) 2*pi];
if theta2>theta1
    t = [theta1 t(t>theta1 & t<=theta2) theta2];
else
    t = [theta1 t(t>theta1) t(t<theta2) theta2];
end

x = r*cos(t)';
y = r*sin(t)';
z = zeros(length(t), 1);

circle0 = [x y z];

tr = translation3d(xc, yc, zc);
rot1 = rotationOz(-psi);
rot2 = rotationOy(-theta);
rot3 = rotationOz(-phi);
trans = tr*rot3*rot2*rot1;

circle = transformPoint3d(circle0, trans);

h = drawCurve3d(circle, varargin{:});


if nargout>0
    varargout{1}=h;
end

