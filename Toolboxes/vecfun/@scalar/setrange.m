function S=setrange(S,a,b,c)
%SETRANGE  Set the range for function variables.
%   S = SETRANGE(S,XYZ) sets the range for all variables
%   of the scalar function S. XYZ is of the format [START END NUMPTS],
%   or just [START END] which will invoke NUMPOINTS from S.
%
%   S = SETRANGE(S,XYZ,VAR) sets the range for a specific variable.
%   VAR can have one of the following values 1, 2 and 3 or also
%   'x', 'y', 'z', 'R', 'r', 'theta' and 'phi' as well.
%
%   S = SETRANGE(S,X,Y,Z) sets the range for all variables specified in
%   X, Y and Z, where X, Y and Z have the same format as for XYZ above.
%
%   See also SIZE, RESIZE.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

error(nargchk(2,4,nargin))
[x y z]=vars(S);
switch(nargin)
case 2
   S.x=fixlen(a,S.x(3));
   S.y=fixlen(a,S.y(3));
   S.z=fixlen(a,S.z(3));
case 3
   switch(b)
   case {1,x}
      S.x=fixlen(a,S.x(3));
   case {2,y}
      S.y=fixlen(a,S.y(3));
   case {3,z}
      S.z=fixlen(a,S.z(3));
   otherwise
      error('Invalid argument.');
   end
case 4
   S.x=fixlen(a,S.x(3));
   S.y=fixlen(b,S.y(3));
   S.z=fixlen(c,S.z(3));
end

function a=fixlen(a,N)
if length(a)==2
   a(3)=N;
elseif length(a)~=3
   error('Vector must contain at least a startpoint and an endpoint.');
end