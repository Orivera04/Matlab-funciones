function f=erzb_f(th0,xf)
% Erzberger's jet stream problem;                   8/16/98
%
f=xf-asinh(tan(th0))+tan(th0)/cos(th0)-2*tan(th0)/cos(th0);