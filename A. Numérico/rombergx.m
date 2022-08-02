function v=rombergx(f,start,finish,intdiv,inity)
% Solves dy/dt=f(t,y) using Romberg's method.
%
% Example call: v=rombergx(f,start,finish,intdiv,inity)
% The initial and final values of t are given by start and finish
% Initial value of y is given by inity.
% The number of interval divisions is given by intdiv.
% The function f(t,y) must be defined by the user. 
% For an example of this function definition, see page 160.
%
for index=1:intdiv
  y0=inity; t0=start;
  intervals=2^index;
  step=(finish-start)/intervals;
  y1=y0+step*feval(f,t0,y0);
  t=t0+step;
  for i=1:intervals
    y2=y0+2*step*feval(f,t,y1);
    t=t+step;
    ye2=y2; ye1=y1; ye0=y0; y0=y1; y1=y2;
  end;
  tableval(index)=(ye0+2*ye1+ye2)/4;
end;
for i=1:intdiv-1
  for j=1:intdiv-i
    table(j)=(tableval(j+1)*4^i-tableval(j))/(4^i-1);
    tableval(j)=table(j);
  end;
  tablep=table(1:intdiv-i);
  disp(tablep)
end;
v=tablep;
