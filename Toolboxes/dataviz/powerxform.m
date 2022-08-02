function y =powerxform(x,power)
%  apply power or root transform to x
%  y =powerxform(x,power)
%  in general, y = x^p
%  for p=0, y = log(x)
%  for 0<p<1, y = x^p-(1-x)^p

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

if power==0
   y = log(x);
elseif power<0
   y = x.^power;
elseif power>=1
   y = x.^power;
else
   y = x.^power-(1-x).^power;
end
