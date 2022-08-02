function siz=size(V)
%SIZE  Size of vector function.
%  SIZE(V) shows ranges and number of points in X, Y and Z
%  from the vector function V.
%
%  D = SIZE(V) returns a vector with the number of points
%  in X, Y and Z from the vector function V.
%
%  See also RESIZE, SETRANGE.

% Copyright (c) 2001-04-14, B. Rasmus Anthin.

pts=[V.x(3) V.y(3) V.z(3)];
str1=mat2str([V.x(1) V.x(2)]);
str2=mat2str([V.y(1) V.y(2)]);
str3=mat2str([V.z(1) V.z(2)]);
str4=mat2str(pts);
if ~nargout
   fprintf \n
   if strcmp(type(V),'cart')
      fprintf('     x-range:   %s\n',str1)
      fprintf('     y-range:   %s\n',str2)
      fprintf('     z-range:   %s\n',str3)
      fprintf('      numpts:   %s\n\n',str4)
   elseif strcmp(type(V),'sph')
      fprintf('         R-range:   %s\n',str1)
      fprintf('     theta-range:   %s\n',str2)
      fprintf('       phi-range:   %s\n',str3)
      fprintf('          numpts:   %s\n\n',str4)
   elseif strcmp(type(V),'cyl')
      fprintf('       r-range:   %s\n',str1)
      fprintf('     phi-range:   %s\n',str2)
      fprintf('       z-range:   %s\n',str3)
      fprintf('        numpts:   %s\n\n',str4)
   end
else
   siz=pts;
end