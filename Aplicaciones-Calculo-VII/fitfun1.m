function enorm=fitfun1(x,tdata,ydata)
%ENORM Norm of fit to example nonlinear function
% f(t) = x(3)+x(4)*exp(x(1)*t)+x(5)*exp(x(2)*t)
%
% ENORM(X,Tdata,Ydata) returns norm(Ydata-f(Tdata))

f=x(3)+x(4)*exp(x(1)*tdata)+x(5)*exp(x(2)*tdata);

enorm=norm(f-ydata);