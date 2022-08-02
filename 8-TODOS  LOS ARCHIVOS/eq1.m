
function dy = eq1(t,y)

% The m-file for the ODE y' = -2ty^2.

dy = -2*t.*y(1).^2;