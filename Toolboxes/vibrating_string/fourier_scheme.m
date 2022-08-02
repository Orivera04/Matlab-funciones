function [res1,res2] = fourier_scheme(func,X,t,dt)

global xdat ydat

xdat = X;
ydat = feval(func,xdat);
a = sincof('initdefl',1,1024);% sine coefficients
%x = X;
t = 0:dt:t;
ntrms = 500;
y = strvib(a,t,xdat,1,ntrms);
res1 = y;
res2 = t;
