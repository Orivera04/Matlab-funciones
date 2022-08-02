function h=meshz(x,y,z,c)
%MESHZ	3-D mesh with reference plane.
%	MESHZ(...) is the same as MESH(...) except that a "curtain" or
%	reference plane is drawn beneath.
%
%	This routine only works for surfaces defined on a rectangular
%	grid.  The matrices X and Y define the axis limits only.
%
%	See also MESH.

% 	Clay M. Thompson 3-20-91
%	Copyright (c) 1984-94 by The MathWorks, Inc.

error(nargchk(1,4,nargin));

if nargin==1,  % Generate x,y matrices for surface z.
  if min(size(x)) == 1 | isstr(x)
      error('Invalid input argument.')
  end
  z = x;
  [m,n] = size(z);
  [x,y] = meshgrid(0:n-1,0:m-1);
  c = z;

elseif nargin==2,
  if isstr(x) | isstr(y)
	error('Invalid input argument.')
  end
  if min(size(x)) == 1 | min(size(y)) == 1
      error('Invalid input argument.')
  end
  z = x; c = y;
  [m,n] = size(z);
  [x,y] = meshgrid(0:n-1,0:m-1);
  if any(size(c) ~= size(z))
      error('Invalid input argument.')
  end

elseif nargin>=3,
  if isstr(x) | isstr(y) | isstr(z)
      error('Invalid input argument.')
  end
  [m,n] = size(z);
  [mx,nx] = size(x);
  [my,ny] = size(y);
  if m == 1 | n == 1
      error('Invalid input argument.')
  end
  if any(size(x)~=size(z)) | any(size(y)~=size(z)),
    % Create x and y vectors that are the same size as z.
    xmin = min(min(x)); ymin = min(min(y));
    xmax = max(max(x)); ymax = max(max(y));
    [x,y] = meshgrid(xmin+(0:n-1)/(n-1)*(xmax-xmin), ...
                     ymin+(0:m-1)/(m-1)*(ymax-ymin));
  end
  if nargin == 3
	c = z;
  end
  if any(size(c) ~= size(z))
      error('Invalid input argument.')
  end
  if any(size(z) ~= size(x)) | any(size(z) ~= size(y))
      error('Invalid input argument.')
  end
end
if isstr(c)
      error('Invalid input argument.')
end

% Define position of curtains
zref = min(min(z(finite(z))));

% Define new x,y,z and then call mesh.
zrow = zref*ones(1,n); zcol = zref*ones(m,1);
d = [1 1]; mm = [m m]; nn = [n n];
newZ = [zref zref   zrow   zref   zref;
        zref zref   z(1,:) zref   zref;
        zcol z(:,1) z      z(:,n) zcol;
        zref zref   z(m,:) zref   zref;
        zref zref   zrow   zref   zref];
newX = [x(d,d),x(d,:),x(d,nn);x(:,d),x,x(:,nn);x(mm,d),x(mm,:),x(mm,nn)];
newY = [y(d,d),y(d,:),y(d,nn);y(:,d),y,y(:,nn);y(mm,d),y(mm,:),y(mm,nn)];

%if (nargin==1) | (nargin==3),
%  hm=mesh(newX,newY,newZ);
%else
%  if size(c)==size(z),  % Expand size of color matrix
    cref = (max(max(c(finite(c))))+min(min(c(finite(c)))))/2;
    crow = cref*ones(2,n); ccol = cref*ones(m,2); cref = cref*ones(2,2);
    c = [cref,crow,cref;ccol,c,ccol;cref,crow,cref];
%    c = [c(d,d),c(d,:),c(d,nn);c(:,d),c,c(:,nn);c(mm,d),c(mm,:),c(mm,nn)];
%  end
  hm=mesh(newX,newY,newZ,c);
%end
if nargout > 0
	h = hm;
end

