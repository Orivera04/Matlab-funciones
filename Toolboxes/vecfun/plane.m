function Pi=plane(o,v1,v2)
%PLANE  Plane from normal.
%   Beta version!!!

% Copyright (c) 2001-09-02, B. Rasmus Anthin.

error(nargchk(2,3,nargin))
o=value(vector(o));v1=value(vector(v1));
if isempty(o) | any(isnan(o))
   error('Vector O must be constant.')
end
if isempty(v1) | any(isnan(v1))
   switch nargin
   case 2, error('Vector N must be constant.')
   case 3, error('Vector V1 must be constant.')
   end
end

x=scalar('x');y=scalar('y');z=scalar('z');
if nargin==2
   n=v1;
else
   v2=value(vector(v2));
   if isempty(v2) | any(isnan(v2))
      error('Vector V2 must be constant.')
   end
   n=cross(v1,v2);
end
Pi=-(n(1)*(x-o(1))+n(2)*(y-o(2)))/n(3)+o(3);
Pi=Pi([],[],0);