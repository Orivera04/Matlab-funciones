function [tvals, yvals]=fhermite(f,start,finish,startval,step)
% Hermite's method for solving 
% first order differential equation dy/dt = f(t,y).
%
% Example call:[tvals, yvals]=fhermite(f,start,finish,startval,step)
% The initial and final values of t are given by start and finish. 
% Initial value of y is given by startval and step size is given by step.
% The function f(t,y) and its derivative must be defined by the user. 
% For an example of this function definition, see page 197.
%
% 3 steps of Runge-Kutta are required so that hermite can start.
% Set up matrices for Runge-Kutta methods
b=[ ];c=[ ];d=[ ];
order=4;
b=[1/6 1/3 1/3 1/6]; d=[0 0.5 0.5 1];
c=[0 0 0 0;0.5 0 0 0;0 0.5 0 0;0 0 1 0];
steps=(finish-start)/step+1;
y=startval; t=start;
ys(1)=startval; [fval(1),df(1)]=feval(f,t,y);
yvals=startval; tvals=start;
for j=2:2
  k(1)=step*fval(1);
  for i=2:order
    k(i)=step*feval(f,t+step*d(i),y+c(i,1:i-1)*k(1:i-1)');
  end;
  y1=y+b*k'; ys(j)=y1; t1=t+step;
  [fval(j),df(j)]=feval(f,t1,y1);
  %collect values together for output
  tvals=[tvals, t1]; yvals=[yvals, y1];
  t=t1; y=y1;
end;
%hermite now applied
h2=step*step/12; er=1;
for i=3:steps
  y1=ys(2)+step*(3*fval(1)-fval(2))/2+h2*(17*df(2)+7*df(1));
  t1=t+step; y1m=y1; y10=y1;
  if i>3, y1m=y1+31*(ys(2)-y10)/30; end;
  [fval(3), df(3)]=feval(f,t1,y1m);
  yc=0; er=1;
  while abs(er)>.0000001
    yp=ys(2)+step*(fval(2)+fval(3))/2+h2*(df(2)-df(3));
    [fval(3), df(3)]=feval(f,t1,yp);
    er=yp-yc; yc=yp;
  end;
  fval(1)=fval(2); df(1)=df(2); fval(2)=fval(3); df(2)=df(3);
  ys(2)=yp;
  tvals=[tvals, t1]; yvals=[yvals, yp];
  t=t1;
end;
