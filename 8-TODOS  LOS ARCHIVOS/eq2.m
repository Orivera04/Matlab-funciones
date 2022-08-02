
function dy = eq2(t, y)

% The odefile for the system of the ODE's:

% y_1'(t) = y_1(t) - 4y_2(t)
% y_2'(t) = -y_1(t) + y_2(t)

dy = [y(1)-4*y(2); -y(1)+y(2)];