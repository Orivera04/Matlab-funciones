%%NAME
%%  egradient - get numerical partial derivatives of matrix 
%%
%%SYNOPSIS
%%  [px py]=egradient(z[,dx[,dy]])
%%
%%PARAMETER(S)
%%  z           z-matrix 
%%  dx          delta x 
%%  dy          delta y 
%%  px          px=dz/dx
%%  py          py=dz/dy
%%
% written by stefan.mueller@fgan.de (C) 2007

function [px,py] = egradient(z,dx,dy)
  if nargin > 3
    eusage('[px py]=egradient(z[,dx[,dy]])');
  end
  if nargin < 3
    dy = dx;
  end
  if nargin < 2
    dx = 1;
    dy = 1;
  end

  [m,n] = size(z);
  if length(dx) == 1
    dx = dx .* (0:n-1);
  end
  if length(dy) == 1
    dy = dy .* (0:m-1);
  end
  
  if size(dx,1)>1
    dx = dx';
  end
  x = zeros(m, n);
  j = 1:m;
  if n > 1
    % left
    d = dx(2) - dx(1);
    x(j, 1) = (z(j, 2) - z(j, 1))./d;
    % right
    d = dx(n) - dx(n-1);
    x(j, n) = (z(j, n) - z(j, n-1))./d;
  end
  if n > 2
    % middle
    k = 1:n-2;
    d = ones(m, 1) * (dx(k+2) - dx(k));
    x(j, k+1) = (z(j, k+2) - z(j, k)) ./d;
  end
  
  if size(dy,2)>1
    dy = dy';
  end; 
  y = zeros(m, n);
  j = 1:n;
  if n > 1
    % left
    d = dy(2) - dy(1);
    y(1,j) = (z(2,j) - z(1,j))./d;
    % right
    d = dy(m) - dy(m-1);
    y(m,j) = (z(m,j) - z(m-1,j))./d;
  end
  if n > 2
    % middle
    k = 1:m-2;
    d = (dy(k+2) - dy(k)) * ones(1,n);
    y(k+1,j) = (z(k+2,j) - z(k,j))./d;
  end
  
  px = (x + sqrt(-1) .* y);
  if nargout == 2
    py = imag(px);
    px = real(px);
  end

