function rotate(h,azel,alpha,origin)
%ROTATE	Rotate an object by angle alpha about a specified direction.
%	ROTATE(H,AZEL,ALPHA,ORIGIN) rotates the object H through angle 
%	ALPHA about an axis described by AZEL, which is a 2-vector of
%	azimuth and elevation or a 3-vector.  The optional argument
%	ORIGIN is a 3-vector used as the origin for rotation.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 4
	origin = [0 0 0];
end
x = get(h,'xdata')-origin(1);
y = get(h,'ydata')-origin(2);
z = get(h,'zdata')-origin(3);
[m,n] = size(z);
if prod(size(x)) < m*n
	[x,y] = meshdom(x,y);
end
% find unit vector for axis of rotation
if prod(size(azel)) == 2 % theta, phi
	phi = pi*azel(1)/180;
	theta = pi*azel(2)/180;
	u = [cos(theta)*cos(phi); cos(theta)*sin(phi); sin(theta)];
elseif prod(size(azel)) == 3 % direction vector
	u = azel(:)/norm(azel);
	theta = asin(u(3));
	phi = atan2(u(2),u(1))-pi/2;
end
newxyz = [x(:), y(:), z(:)];
alph = alpha*pi/180;
cosa = cos(alph);
sina = sin(alph);
vera = 1 - cosa;
x = u(1);
y = u(2);
z = u(3);
rot = [cosa+x^2*vera x*y*vera-z*sina x*z*vera+y*sina; ...
       x*y*vera+z*sina cosa+y^2*vera y*z*vera-x*sina; ...
       x*z*vera-y*sina y*z*vera+x*sina cosa+z^2*vera];
newxyz = newxyz*rot;
newx = origin(1) + reshape(newxyz(:,1),m,n);
newy = origin(2) + reshape(newxyz(:,2),m,n);
newz = origin(3) + reshape(newxyz(:,3),m,n);
set(h,'xdata',newx,'ydata',newy,'zdata',newz);
