function [area]=diagramintegral(x,y)
%DIAGRAMINTEGRAL Integral of the given numerical data.
%   DIAGRAMINTEGRAL(X,Y) finds the integral of the data vector Y that 
%   corresponds to the indices X.  The trapezoid method is used for 
%   integration.  The routine is intended to work with the output from 
%   DIAGRAM to create a moment diagram from a shear diagram, or other such 
%   integrations.
%
%   See also DIAGRAM, DISPLACE.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

if length(x)~=length(y) 
  disp('Vectors must be the same length.')
  return
end

DeltaX=x(2)-x(1);
n=length(x);

subarea(1)=0;
for gapli=2:n %Generic All Purpose Looping Index
  subarea(gapli)=(y(gapli-1)+y(gapli))*DeltaX/2;
end

area=cumsum(subarea);
