function [xnorm,xuvec]=fnuvec(x)
% CALL: [xnorm,xuvec]=fnuvec(x)
% Compute norm (xnorm) and unit vector (xuvec) of vector x
if x == 0
 xnorm =0
 xuvec =x
else
xnorm=norm(x);
xuvec=x./xnorm;
end