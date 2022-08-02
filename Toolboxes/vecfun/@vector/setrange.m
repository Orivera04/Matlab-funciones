function V=setrange(V,a,b,c)
%SETRANGE  Set the range for function variables.
%   V = SETRANGE(V,XYZ) sets the range for all variables
%   of the vector function V. XYZ is of the format [START END NUMPTS],
%   or just [START END] which will invoke NUMPOINTS from V.
%
%   V = SETRANGE(V,XYZ,VAR) sets the range for a specific variable.
%   VAR can have one of the following values 1, 2 and 3 or also
%   'x', 'y', 'z', 'R', 'r', 'theta' and 'phi' as well.
%
%   V = SETRANGE(V,X,Y,Z) sets the range for all variables specified in
%   X, Y and Z, where X, Y and Z have the same format as for XYZ above.
%
%   See also SIZE, RESIZE.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

error(nargchk(2,4,nargin));
[x y z]=vars(V);
switch(nargin)
case 2
   V.x=fixlen(a,V.x(3));
   V.y=fixlen(a,V.y(3));
   V.z=fixlen(a,V.z(3));
case 3
   switch(b)
   case {1,x}
      V.x=fixlen(a,V.x(3));
   case {2,y}
      V.y=fixlen(a,V.y(3));
   case {3,z}
      V.z=fixlen(a,V.z(3));
   otherwise
      error('Invalid argument.');
   end
case 4
   V.x=fixlen(a,V.x(3));
   V.y=fixlen(b,V.y(3));
   V.z=fixlen(c,V.z(3));
end

function a=fixlen(a,N)
if length(a)==2
   a(3)=N;
elseif length(a)~=3
   error('Vector must contain at least a startpoint and an endpoint.');
end