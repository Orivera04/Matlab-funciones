function y=type(V)
%TYPE  Display type of coordinates.
%   Displays either 'cart', 'sph' or 'cyl'.

% Copyright 2001-04-15, B. Rasmus Anthin.

if ~nargout
   fprintf('\n     coords:   %s\n\n',V.coords)
else
   y=V.coords;
end