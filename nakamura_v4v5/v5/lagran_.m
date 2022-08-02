% function Lagran_(x, f, xi) interpolates data 
% by Lagrange interpolation. 
% x is an abscissas vector, f is an ordinates vector, 
% xi is a vecotr of abscissa for which f is to be 
% interpolated.
% Copyright S. Nakamura, 1995
function fi = Lagran_(x, f, xi)
fi=zeros(size(xi));
np1=length(f);
for i=1:np1
  z=ones(size(xi));
  for j=1:np1
    if i~=j, z = z.*(xi - x(j))/(x(i)-x(j));end
  end
  fi=fi+z*f(i);
end
return

