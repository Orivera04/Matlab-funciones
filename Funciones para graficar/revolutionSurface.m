function varargout = revolutionSurface(varargin)
%REVOLUTIONSURFACE create a surface of revolution from a planar curve
%
%   usage : 
%   [X Y Z] = revolutionSurface(XT, YT, N);
%   create the surface of revolution of parametrized function (xt, yt),
%   with N equally spaced slices, around the Ox axis.
%
%   [X Y Z] = revolutionSurface(CURVE, N);
%   is the same, but generating curve is given in a single parameter CURVE,
%   which is a [Nx2] array of 2D points.
%
%   [X Y Z] = revolutionSurface(XT, YT, THETA)
%   [X Y Z] = revolutionSurface(CURVE, THETA)
%   where THETA is a vector, uses values of THETA for computing
%
%   Surface can be displayed using :
%   H = surf(X, Y, Z);
%   H is a handle to the created patch.
%
%   revolutionSurface(...);
%   by itself, directly shows the created patch.
%
%   Example:
%   % draws a piece of torus
%   circle = circleAsPolygon([0 10 3], 50);
%   [x y t] = revolutionSurface(circle, linspace(0, 4*pi/3, 50));
%   surf(x, y, t);
%   axis equal;
%
%
%   TODO : add possibility to specify axis of revolution
%
%   See also: surf, 
%       surfature (on Matlab File Exchange)
%
%
%   ------
%   Author: David Legland
%   e-mail: david.legland@jouy.inra.fr
%   Created: 2004-04-09
%   Copyright 2005 INRA - CEPIA Nantes - MIAJ Jouy-en-Josas.

%   based on function cylinder from matlab
%   2006-06-31 : fix bug when passing 3 parameters

n = 50;
if length(varargin)==2
    curve = varargin{1};
    xt = curve(:,1);
    yt = curve(:,2);
    n = varargin{2};
elseif length(varargin)==3
    xt = varargin{1};
    yt = varargin{2};
    n = varargin{3};
end

% ensure length is enough
m = length(xt);
if m==1
    xt = [xt xt];
end

% ensure x and y are vertical vectors
xt = xt(:);
yt = yt(:);
        
% create revolution angles
if length(n)==1
    theta = (0:n)/n*2*pi;
else
    theta = n(:)';
end
sintheta = sin(theta);
%sintheta(end) = 0;

% compute surface vertices
x = yt * cos(theta);
y = yt * sintheta;
z = xt * ones(size(theta));

% format output depending on how many output parameters
if nargout == 0
    surf(x,y,z)
elseif nargout==3
    varargout{1} = x;
    varargout{2} = y;
    varargout{3} = z;
end


