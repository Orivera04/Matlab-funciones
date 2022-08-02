function [tvals, yvals]=fhamming(f,start,finish,startval,step)
% Hamming's method for solving 
% first order differential equation dy/dt = f(t,y).
%
% Example call: [tvals, yvals]=fhamming(f,start,finish,startval,step)
% The initial and final values of t are given by start and finish. 
% Initial value of y is given by startval and step size is given by step.
% The function f(t,y) must be defined by the user. 
% For an example of this function definition, see page 160.
%
% 3 steps of Runge-Kutta are required so that hamming can start.
% Set up matrices for Runge-Kutta methods
b=[ ];c=[ ];d=[ ];
order=4;
b=[1/6 1/3 1/3 1/6]; d=[0 0.5 0.5 1];
c=[0 0 0 0;0.5 0 0 0;0 0.5 0 0;0 0 1 0];
steps=(finish-start)/step+1;
y=startval;t=start;
fval(1)=feval(f,t,y);
ys(1)=startval;
yvals=startval; tvals=start;
for j=2:4
  k(1)=step*feval(f,t,y);
  for i=2:order
    k(i)=step*feval(f,t+step*d(i),y+c(i,1:i-1)*k(1:i-1)');
  end;
  y1=y+b*k'; ys(j)=y1; t1=t+step; fval(j)=feval(f,t1,y1);
  %collect values together for output
  tvals=[tvals, t1]; yvals=[yvals, y1]; t=t1; y=y1;
end;
%Hamming now applied
for i=5:steps
  y1=ys(1)+4*step*(2*fval(4)-fval(3)+2*fval(2))/3;
  t1=t+step; y1m=y1;
  if i>5, y1m=y1+112*(c-p)/121; end;
  fval(5)=feval(f,t1,y1m);
  yc=(9*ys(4)-ys(2)+3*step*(2*fval(4)+fval(5)-fval(3)))/8;
  ycm=yc+9*(y1-yc)/121;
  p=y1; c=yc;
  fval(5)=feval(f,t1,ycm);
  fval(2)=fval(3); fval(3)=fval(4); fval(4)=fval(5);
  ys(1)=ys(2); ys(2)=ys(3); ys(3)=ys(4); ys(4)=ycm;
  tvals=[tvals, t1]; yvals=[yvals, ycm];
  t=t1;
end;
