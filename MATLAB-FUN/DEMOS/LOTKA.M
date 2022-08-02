function yp = lotka(t,y)
%LOTKA	Lotka-Volterra predator-prey model.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

yp = diag([1 - .01*y(2), -1 + .02*y(1)])*y;
