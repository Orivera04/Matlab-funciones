function [msg,x,y,z,xi,yi] = xyzchk(x,y,z,xi,yi,map)
%XYZCHK Check arguments to 3-D data routines.
%
%	[MSG,X,Y,Z] = XYZCHK(X,Y,Z)
%	  or
%	[MSG,X,Y,Z,XI,YI] = XYZCHK(X,Y,Z,XI,YI)
%
%	[MSG,X,Y,Z,XI,YI] = XYZCHK(X,Y,Z,XI,YI,'map') maps data 
%	coordinates (X,Y) and (XI,YI) to an equally spaced domain
%	when data domain is not equally spaced.  Note that (X,Y) 
%	are assumed to be plaid in this case.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

msg = [];

[m,n] = size(z);
if min(size(z))>1, % z is a matrix

  % Convert x,y to row and column matrices if necessary.
  if min(size(x))==1 & min(size(y))==1,
    [x,y] = meshgrid(x,y);
    if size(x,2)~=n | size(y,1)~=m,
      msg = 'The lengths of X and Y must match the size of Z.';
      return
    end
  elseif min(size(x))==1 | min(size(y))==1,
    msg = 'X and Y must both be vectors or both be matrices.';
    return
  else
    if any(size(x)~=size(z)) | any(size(y)~=size(z)),
      msg = 'Matrices X and Y must be the same size as Z.';
      return
    end
  end

else % z is a vector
  if min(size(x))~=1 | min(size(y))~=1,
    msg = 'X and Y must be vectors when Z is.';
    return
  elseif length(x)~=length(z) | length(y)~=length(z),
    msg = 'X and Y must be same length as Z.';
    return
  end
end

% Check for non-equally spaced data.  If so, map (x,y) and
% (xi,yi) to matrix (row,col) coordinate system.
if nargin==6,
  xx = x(1,:); yy = y(:,1);
  dx = diff(xx); dy = diff(yy);
  if (max(abs(diff(dx))) > eps*max(xx)) | ...
     (max(abs(diff(dy))) > eps*max(yy)),
    if any(dx < 0), % Flip orientation of data so x is increasing.
      x(:) = fliplr(x); y(:) = fliplr(y); z(:) = fliplr(z);
      xx(:) = fliplr(xx); dx(:) = -fliplr(dx);
    end
    if any(dy < 0), % Flip orientation of data so y is increasing.
      x(:) = flipud(x); y(:) = flipud(y); z(:) = flipud(z);
      yy(:) = flipud(yy); dy(:) = -flipud(dy);
    end

    if any(dx<=0) | any(dy<=0), 
      msg = 'X and Y must be monotonic.';
      return
    end

    ui = zeros(size(xi));
    d = (xi < xx(1));
    for i=1:length(xx)-1,
      e = (xi <= xx(i+1)) & ~d;
      f = find(e);
      if ~isempty(f), ui(f) = i + (xi(f)-xx(i))/dx(i); end
      d = d | e;
    end

    vi = zeros(size(yi));
    d = (yi < yy(1));
    for i=1:length(yy)-1,
      e = (yi <= yy(i+1)) & ~d;
      f = find(e);
      if ~isempty(f), vi(f) = i + (yi(f)-yy(i))/dy(i); end	
      d = d | e;
    end

    [x,y] = meshgrid(1:size(x,2),1:size(y,1));
    xi = ui; yi = vi;
  end
end

if nargin>3, % Check interpolation arguments

  % If x is a row and y is a column then build xi,yi matrices.
  if size(xi,1)==1 & size(yi,2)==1,
    [xi,yi] = meshgrid(xi,yi);
  elseif any(size(xi)~= size(yi)), % Also create matrix if sizes differ
    [xi,yi] = meshgrid(xi,yi);
  end

end
