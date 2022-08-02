function [x,y,z,xs,ys,zs]=vars(f)
%VARS  Extract coordinates from function.
%   [X,Y,Z,XS,YS,ZS] = VARS(F) where F can be either a scalar or a vector function.
%   X, Y and Z are the strings containing either 'x', 'y' and 'z', or
%   'R', 'theta' and 'phi', or 'r', 'phi' and 'z' depending on what coordinates
%   the function F are currently using. XS, YS and ZS contains required amount of spaces
%   for indenting the functions right.
%   This function is used internally by the classes SCALAR and VECTOR.
%
%   See also TYPE.

% Copyright (c) 2001-04-22, B. Rasmus Anthin

switch(type(f))
case 'cart'
   x='x';y='y';z='z';
   xs='';zs='';
case 'sph'
   x='R';y='theta';z='phi';
   xs(1:4)=' ';zs(1:2)=' ';
case 'cyl'
   x='r';y='phi';z='z';
   xs(1:2)=' ';zs(1:2)=' ';
end
ys='';