function siz=size(S)
%SIZE  Size of scalar function.
%  SIZE(S) shows ranges and number of points in X, Y and Z
%  from the scalar function S.
%
%  D = SIZE(S) returns a vector with the number of points
%  in X, Y and Z from the scalar function S.
%
%  See also RESIZE, SETRANGE.

% Copyright (c) 2001-04-14, B. Rasmus Anthin.

pts=[S.x(3) S.y(3) S.z(3)];
str1=mat2str([S.x(1) S.x(2)]);
str2=mat2str([S.y(1) S.y(2)]);
str3=mat2str([S.z(1) S.z(2)]);
str4=mat2str(pts);
if ~nargout
   fprintf \n
   if strcmp(S.coords,'cart')
      fprintf('     x-range:   %s\n',str1)
      fprintf('     y-range:   %s\n',str2)
      fprintf('     z-range:   %s\n',str3)
      fprintf('      numpts:   %s\n\n',str4)
   elseif strcmp(S.coords,'sph')
      fprintf('         R-range:   %s\n',str1)
      fprintf('     theta-range:   %s\n',str2)
      fprintf('       phi-range:   %s\n',str3)
      fprintf('          numpts:   %s\n\n',str4)
   elseif strcmp(S.coords,'cyl')
      fprintf('       r-range:   %s\n',str1)
      fprintf('     phi-range:   %s\n',str2)
      fprintf('       z-range:   %s\n',str3)
      fprintf('        numpts:   %s\n\n',str4)
   end
else
   siz=pts;
end