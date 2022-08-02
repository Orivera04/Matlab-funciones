function B=abs(A)
%ABS  Vector length.
%   ABS(V) is the absolute value of the vector function V.
%   Ie ABS(V) = sqrt(V.x^2 + V.y^2 + V.z^2)
%
%   See also ANGLE.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=vec2sca(A,1);
B=struct(B);
if isempty(inputname(1))
   B.f=['|(' A.fx ',' A.fy ',' A.fz ')|'];
else
   B.f=['|' inputname(1) '|'];
end
if isempty(B.xval), x0='0';else x0=B.xval;end
if isempty(B.yval), y0='0';else y0=B.yval;end
if isempty(B.zval), z0='0';else z0=B.zval;end
B.F=['sqrt((' A.Fx '-' x0 ').^2+'...
      '(' A.Fy '-' y0 ').^2+'...
      '(' A.Fz '-' z0 ').^2)'];
B=scalar(B);