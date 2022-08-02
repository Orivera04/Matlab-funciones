function ydot = lorenzeq(t,y)
%LORENZEQ Equation of the Lorenz chaotic attractor.
%	ydot = lorenzeq(t,y).
%	The differential equation is written in almost linear form.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

global SIGMA RHO BETA

A = [ -BETA    0     y(2)  
         0  -SIGMA   SIGMA 
      -y(2)   RHO    -1  ];

ydot = A*y;
