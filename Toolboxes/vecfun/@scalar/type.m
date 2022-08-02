function y=type(S)
%TYPE  Display type of coordinates.
%   Displays either 'cart', 'sph' or 'cyl'.

% Copyright 2001-04-15, B. Rasmus Anthin.

if ~nargout
   fprintf('\n     coords:   %s\n\n',S.coords)
else
   y=S.coords;
end