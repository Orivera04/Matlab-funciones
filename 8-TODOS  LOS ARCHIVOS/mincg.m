function [res, noiter]=mincg(f,derf,ftau,x,tol)
% Finds local minimum of a multivariable non-linear function in n variables
% using conjugate gradient method.
%
% Example call: res=mincg(f,derf,ftau,x,tol)
% f is a user defined multi-variable function, 
% derf a user defined function of n first order partial derivatives.
% ftau is the line search function. For example 
%function ftauv=ftau(tau);
%global p1 d1
%q1=p1+tau*d1;
%ftauv=feval('func',q1);
% x is a column vector of n starting values, tol gives required accuracy.
% WARNING. Not guarenteed to work with all functions. 
% WARNING. For difficult problems the linear search accuracy may have to be adjusted.
%
global p1 d1
n=size(x); noiter=0;
%Calculate initial gradient
df= feval(derf,x);
%main loop
while norm(df)>tol
  noiter=noiter+1;
  df= feval(derf,x); d1=-df;
  %Inner loop
  for inner=1:n
    p1=x;
    %Linear search accuracy = 0.00005; reduce for greater accuracy.
    tau=fmin(ftau,-10,10,[0 0.00005]);
    % calculate new x
    x1=x+tau*d1;
    %Save previous gradient
    dfp=df;
    %Calculate new gradient
    df= feval(derf,x1);
    %Update x and d
    d=d1; x=x1;
    %Conjugate gradient method
    beta=(df'*df)/(dfp'*dfp);
    d1=-df+beta*d;
  end;
end;
res=x1;
disp('Number of iterations= ');disp(noiter);
disp('Solution'); disp(x1);
disp('Gradient'); disp(df);
