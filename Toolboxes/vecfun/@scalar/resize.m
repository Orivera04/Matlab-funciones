function S=resize(S,Nx,Ny,Nz)
%RESIZE  Resize scalar function.
%   S = RESIZE(S,NX,NY,NZ) changes the size of the scalar function S.
%   NX, NY and NZ are the number of points used by different operations on S.
%
%   S = RESIZE(S,[NX NY NZ]) does the same thing.
%
%   S = RESIZE(S,N) resizes S with Nx = N, Ny = N and Nz = N.
%
%   S = RESIZE(S,N,VAR) changes the NUMPOINTS value for a specific variable.
%   VAR can have one of the following values 1, 2, and 3 or also
%   'x', 'y', 'z', 'R', 'r', 'theta' and 'phi' as well.
%
%   See also SIZE, SETRANGE.

% Copyright (c) 2001-04-22, B. Rasmus Anthin.

error(nargchk(2,4,nargin))
[x y z]=vars(S);
switch(nargin)
case 2
   switch(length(Nx))
   case 1
      Ny=Nx;Nz=Nx;
   case 3
      foo=Nx;
      Nx=foo(1);Ny=foo(2);Nz=foo(3);
   otherwise
      error('Length of vector in argument must be 1 or 3.')
   end
   S.x(3)=Nx;
   S.y(3)=Ny;
   S.z(3)=Nz;
case 3
   switch(Ny)
   case {1,x}
      S.x(3)=Nx;
   case {2,y}
      S.y(3)=Nx;
   case {3,z}
      S.z(3)=Nx;
   end
case 4
   S.x(3)=Nx;
   S.y(3)=Ny;
   S.z(3)=Nz;
end