function [m,tps]= min(p);
% MIN  find minimum of polynomial if it exists

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:34 $



d1=diff(p);
tps= code(p,roots(d1));

d2=diff(d1);
d2vals= eval(d2,tps);

% get rid of complex roots, maxima and points of inflexion
tol= 1e-8;

tps = tps(abs(tps-real(tps))<tol & abs(d2vals-real(d2vals))<tol & real(d2vals)>0);
m = eval(p,tps);