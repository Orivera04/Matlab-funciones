function dirfield(xmin,xmax,ymin,ymax)
% This function plots the direction field for
% an autonomous system of D.E.'s.
%   The user must have created an M-file
%   for function de_rhs(t,y) which evaluates the right
%   hand side of the differential equations 
%   dy(1)/dt=...
%   dy(2)/dt=...  where x=y(1) and y=y(2).

A=(xmax-xmin)/100;
B=(ymax-ymin)/100;
t=1;
for y=ymin+2*B:6*B:ymax-2*B
  for x=xmin+2*A:6*A:xmax-2*A
    z=[x,y]';
    zprime=de_rhs(t,z);
    if zprime(1) ~= 0
       M=zprime(2)/zprime(1);
    else
       M=1.0e6;
    end
    c=2/sqrt( (1/A)^2+(M/B)^2 );
    d=M*c;
    xpt=[x-c,x+c];
    ypt=[y-d;y+d];
    line(xpt,ypt);
  end
end