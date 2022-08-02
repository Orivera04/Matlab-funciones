function z=vibfun(x)
%
% z=vibfun(x)
% ~~~~~~~~~~~
%
% This function evalautes the least square  
% error for a set of vibration data. The data
% vectors timdat and ydat are passed as global
% variables. The function to be fitted is:
%
%   y=a*exp(b*t)*cos(c*t+d)
%
% x - a vector defining a,b,c and d
%
% z - the square of the norm for the vector 
%     of error deviations between the data and 
%     results the equation gives for current 
%     parameter values
%
% User m functions called:  none
%----------------------------------------------

global timdat ydat
a=x(1); b=-abs(x(2)); c=abs(x(3)); d=x(4);
z=a*exp(b*timdat).*cos(c*timdat+d); 
z=norm(z-ydat)^2;