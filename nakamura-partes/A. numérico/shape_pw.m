% shape_pw(x) converts a shape function in the
% Lagrange interpolation to a power series form.
% x is a vector of abscissas of points.
% Copyright S. Nakamura, 1995
function p = shape_pw(x)
np = length(x);
for j=1:np
   y = zeros(1,np); y(j) = 1;
   p(j,:)=polyfit(x,y,np-1);
end

