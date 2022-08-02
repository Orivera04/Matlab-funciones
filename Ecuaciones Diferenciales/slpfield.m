function slpfield(tmin,tmax,ymin,ymax)
% This function plots the slope field for
% a differential equation dy/dt=dfun(t,y)
%   The user must have created an M-file
%   for function dfun(t,y) which evaluates the right
%   hand side of the differential equation.

A=(tmax-tmin)/100;
B=(ymax-ymin)/100;

for y=ymin+2*B:6*B:ymax-2*B
  for t=tmin+2*A:6*A:tmax-2*A
    M=dfun(t,y);
    c=2/sqrt( (1/A)^2+(M/B)^2 );
    d=M*c;
    tpt=[t-c,t+c];
    ypt=[y-d;y+d];
    line(tpt,ypt);
  end
end
