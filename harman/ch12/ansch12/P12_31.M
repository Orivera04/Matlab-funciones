% P12_31.M Arclength of input function
% (Requires Symbolic Math Toolbox)
% Input function in MATLAB format ; i.e. x^2 or sin(x)
clear
y=input('Function f= ','s')
dy=diff(y)
dy2=sym(dy)*sym(dy)
dssq=sym(dy2)+sum(1)   % Define integrand
ds=sym(dssq)^sym(1/2)
s=int(ds)
pretty(s)
%
% Version 5: Removed symmul, symadd, sympow and changed call to pretty
%
