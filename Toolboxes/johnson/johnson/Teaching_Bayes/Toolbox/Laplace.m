function [mode,var,log_int]=laplace(logpost,start,iter,par)
% LAPLACE summarizes a posterior density by the Laplace method
%	[MODE,VAR,LOG_INT]=LAPLACE(LOGPOST,START,ITER,PAR) returns the mode 
%	MODE, the variance-covariance matrix VAR, and estimate LOG_INT of log of 
%	integral of posterior density, where LOGPOST is function containing
%	definition of log posterior, START is initial guess at mode,
%	ITER is number of iterations in Newton-Raphson algorithm, and PAR
%	is the vector of associated parameters in the function definition.

mode=start;
for i=1:iter
  [mode,var,log_int]=nr(logpost,mode,par);mode
end

function [new,h,int]=nr(f,old,par)

%  newton-raphson step
%  [new,h,int]=nr(f,old,par)
%  where f is definition of log density defined at vector of values,
%  old is guess at mode, and par is vector of associated parameters
%  output is new guess, variance estimate, and estimate of log-integral

p=length(old);
h=-inv(f2(f,old,par));
new=old+f1(f,old,par)*h;
int=p/2*log(2*pi)+.5*log(det(h))+feval(f,new,par);

function val=f1(f,x,par)
h=.0001; val=[];
s=[-h/2;h/2];
x2=ones(2,1)*x;
for i=1:length(x)
   y=x2; y(:,i)=y(:,i)+s;
   v=diff(feval(f,y,par))/h;
   val=[val v];
end

function val=f2(f,x,par)
h=.0001;
n=length(x); val=zeros(n);
s=[-h;0;h];
x2=ones(3,1)*x; 
for i=1:n
   y=x2; y(:,i)=y(:,i)+s;
   t=feval(f,y,par);
   val(i,i)=(t(1)-2*t(2)+t(3))/h^2;
end
s=[h/2 h/2; -h/2 h/2; h/2 -h/2; -h/2 -h/2];
x2=ones(4,1)*x;
for i=1:n
for j=(i+1):n
  y=x2; y(:,[i j])=y(:,[i j])+s;
  t=feval(f,y,par);
  v=(t(1)-t(2)-t(3)+t(4))/h^2;
  val(i,j)=v; val(j,i)=v;
end
end
   

