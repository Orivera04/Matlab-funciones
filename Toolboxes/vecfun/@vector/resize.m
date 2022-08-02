function V=resize(V,Nx,Ny,Nz)
%RESIZE  Resize vector function.
%   V = RESIZE(V,NX,NY,NZ) changes the size of the vector function V.
%   NX, NY and NZ are the number of points used by different operations on V.
%
%   V = RESIZE(V,[NX NY NZ]) does the same thing.
%
%   V = RESIZE(V,N) resizes V with Nx = N, Ny = N and Nz = N.
%
%   V = RESIZE(V,N,VAR) changes the NUMPOINTS value for a specific variable.
%   VAR can have one of the following values 1, 2, and 3 or also
%   'x', 'y', 'z', 'R', 'r', 'theta' and 'phi' as well.
%
%   See also SIZE, SETRANGE.

% Copyright (c) 2001-04-22, B. Rasmus Anthin.

error(nargchk(2,4,nargin))
[x y z]=vars(V);
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
   V.x(3)=Nx;
   V.y(3)=Ny;
   V.z(3)=Nz;
case 3
   switch(Ny)
   case {1,x}
      V.x(3)=Nx;
   case {2,y}
      V.y(3)=Nx;
   case {3,z}
      V.z(3)=Nx;
   end
case 4
   V.x(3)=Nx;
   V.y(3)=Ny;
   V.z(3)=Nz;
end