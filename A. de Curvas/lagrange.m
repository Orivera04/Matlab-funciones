function y=lagrange(x,pointx,pointsy,dydx_on)
%
%LAGRANGE  approx a point-defined function using the Lagrange polynomial interpolation
%
%    LAGRANGE(X,POINTX,POINTY) approx the function definited by the points:
%    P1=(POINTX(1),POINTY(1)), P2=(POINTX(2),POINTY(2)), ..., PN(POINTX(N),POINTY(N))
%    and calculate it in each elements of X
%
%    If POINTX and POINTY have different number of elements the function will return the NaN value
% DERIVATIVE FUNCTIONS
%    LAGRANGE(X,POINTX,POINTY,1) computes the derivative at X
%    LAGRANGE(X,POINTX,POINTY,2) computes the derivative at X by finding the solution at X, then re-running with option 1 to find the derivative there.  This is numerically unstable for small step size of X and should not be trusted at tails of the data set.  However, it can be more accurate than option 1. 
%
%    NOTE: When dealing with lots of control points, this algorithm works best by buffering the interpolation period with more control points outside that epoch.  However, the more control points, the slower this gets.
%
%    function wrote by: Calzino
%    7-oct-2001
%    modified by GGW on 2-AUG-2006
%
if nargin < 4
  dydx_on = 0 ;  % so differentiation can be in the same script 
end

% operation on rows of data (i.e., px = [x0 x1 ... xn], py = [y0 y1 ... yn])
x = x(:).' ; 
[ytr,pointsy,pointx] = dimchecking(pointsy,pointx) ; 

s = size(x,2) ; 
n = size(pointx,2);

if dydx_on == 1
  Linit = zeros(n,s) ; 
else
  Linit = ones(n,s);
end

y=zeros(size(pointsy,1),s);

for h = 1:size(pointsy,1) ; 
  L = Linit ; 
  pointy = pointsy(h,:) ; 

  for j=1:n
    for i=1:n
      if (j~=i)
        if dydx_on == 1
          dlprod = ones(1,s) ;
          for k = 1:n
            if k~=j && k~=i
              dlprod = dlprod .* (x-pointx(k))/(pointx(j)-pointx(k)) ; 
            end 
          end
          L(j,:) = L(j,:) + 1/(pointx(j)-pointx(i))*dlprod ; 
        else
          L(j,:) = L(j,:) .* (x-pointx(i))./(pointx(j)-pointx(i));
        end
      end
    end
  end

  for j = 1:n
    y(h,:) = y(h,:) + pointy(j)*L(j,:);
  end

  if dydx_on == 2
    y(h,:) = lagrange(x,x,y,1) ; 
  end

end

if ytr 
  y = y.' ; 
end

%=========================================
function [ytr,pointsy,pointx] = dimchecking(pointsy,pointx)  
xtr = 0 ; 
if length(pointx) ~= length(pointx(:))
  error('pointx must be a vector')
end
if size(pointx) ~= size(pointx(:).')
  xtr = 1 ; 
end 
pointx = pointx(:).' ; 

ytr = 0 ;  % y got transposed? had to transpose input, yes = 1

if numel(pointsy) == length(pointsy) % pointsy is a vector
  tempy = pointsy(:).' ; 
  if size(tempy) ~= size(pointsy)
    ytr = 1 ;  
  end
  pointsy = tempy ; 
else % pointsy is an array 
  if size(pointsy,2) ~= size(pointx,2) 
    if size(pointsy,1) ~= size(pointx,2)  % no hope for a transpose
      error('pointsy must have same number of states as elements in pointx')
    else
    pointsy = pointsy.' ; 
    ytr = 1 ; 
    end
  end
  if size(pointsy) == size(pointsy.')  % square matrix case, assume that rows 
    if xtr                             % of pointx match rows of pointsy or
      pointsy = pointsy.' ;            % cols of pointx match cols of pointsy
      ytr = 1 ; 
      disp('Warning: pointx is a column, I will assume corresponding pointsy are columns')
    end
      disp('Warning: pointx is a row, I will assume corresponding pointsy are rows')
  end
end

if size(pointsy,2) ~= size(pointx,2)
  error('pointsy must have same number of states as elements in pointx')
end 

return


