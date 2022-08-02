function [h1,h2,h3]=coeffs(f)
%COEFFS  Coordinate coefficients.
%   [H1,H2,H3] = COEFFS(F) returns the three coordinate
%   coefficients for a scalar or vector function F.

% Copyright (c) 2001-04-23, B. Rasmus Anthin

fs=struct(f);
x=fs.x;y=fs.y;z=fs.z;
switch(type(f))
case 'cart'
   h1=scalar(x,y,z,'1');
   h2=scalar(x,y,z,'1');
   h3=scalar(x,y,z,'1');
case 'sph'
   h1=scalar(x,y,z,'1','sph');
   h2=scalar(x,y,z,'R','sph');
   h3=scalar(x,y,z,'R*sin(theta)','sph');
case 'cyl'
   h1=scalar(x,y,z,'1','cyl');
   h2=scalar(x,y,z,'r','cyl');
   h3=scalar(x,y,z,'1','cyl');
end