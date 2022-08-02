function [tout,rout] = rose(theta,x)
%ROSE	Plot rose or angle histogram.
%
%	ROSE(THETA) plots the angle histogram for the angles in THETA.  
%	The angles in the vector THETA must be specified in radians.
%
%	ROSE(THETA,N) where N is a scalar, uses N equally spaced bins 
%	from 0 to 2*PI.  The default value for N is 20.
%
%	ROSE(THETA,X) where X is a vector, draws the histogram using the
%	bins specified in X.
%
%	[T,R] = ROSE(...) returns the vectors T and R such that 
%	POLAR(T,R) is the histogram.  No plot is drawn.

%	Clay M. Thompson 7-9-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if isstr(theta)
        error('Input arguments must be numeric.');
end
theta = rem(rem(theta,2*pi)+2*pi,2*pi); % Make sure 0 <= theta <= 2*pi
if nargin==1,
  x = [0:19]*pi/10+pi/20;

elseif nargin==2,
  if isstr(x)
        error('Input arguments must be numeric.');
  end
  if max(size(x))==1,
    x = [0:x-1]*2*pi/x + pi/x;
  else
    x = sort(rem(x(:)',2*pi));
  end

end
if isstr(x) | isstr(theta)
        error('Input arguments must be numeric.');
end
[nn,xx] = hist(theta,x);	% Get histogram

% Form radius values for histogram triangle
if min(size(nn))==1, % Vector
  nn = nn(:); 
 xx=xx(:);
end
[m,n] = size(nn);
mm = 4*m;
r = zeros(mm,n);
r(2:4:mm,:) = nn;
r(3:4:mm,:) = nn;

% Form theta values for histogram triangle from triangle centers (xx)
yy = [2*xx(1)-xx(2);xx;2*xx(m)-xx(m-1)];
zz = ([0;yy] + [yy;0])/2;
zz = zz(2:m+2,:);

t = zeros(mm,1);
t(2:4:mm) = zz(1:m);
t(3:4:mm) = zz(2:m+1);

if nargout==0
  polar(t,r)
  return
end

if min(size(nn))==1,
  tout = t'; rout = r';
else
  tout = t; rout = r;
end


