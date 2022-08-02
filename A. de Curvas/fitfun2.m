function [enorm,p]=fitfun2(x,tdata,ydata)
%ENORM Norm of fit to example nonlinear function
% f(t) = p(1)+p(2)*exp(x(1)*t)+p(3)*exp(x(2)*t)
%
% ENORM(X,Tdata,Ydata) returns norm(Ydata-f(Tdata))
%
% [e,p]=ENORM(...) returns the linear least squares
%                  paramter vector p

% solve linear least squares problem

E = [ones(size(tdata)) exp(x(1)*tdata) exp(x(2)*tdata)];
p = E\ydata; % least squares solution for p=[a b c]'

% use p vector to compute error norm
f = p(1)+p(2)*exp(x(1)*tdata)+p(3)*exp(x(2)*tdata);

enorm = norm(f-ydata);