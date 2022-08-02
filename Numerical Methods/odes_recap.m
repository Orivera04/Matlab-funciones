%% Ordinary Differential Equations Chapter Recap 
% This is an executable program that illustrates the statements
% introduced in the Ordinary Differential Equations Chapter
% of "Experiments in MATLAB".
% You can access it with
%
%    odes_recap
%    edit odes_recap
%    publish odes_recap
%
% Related EXM programs
%
%    ode1

%% Spacewar Orbit Generator.
    x = 0;
    y = 1;
    h = 1/4;
    n = 2*pi/h;
    plot(x,y,'.')
    hold on
    for k = 1:n
       x = x + h*y;
       y = y - h*x;
       plot(x,y,'.')
    end
    hold off
    axis square
    axis([-1.1 1.1 -1.1 1.1])

%% An Anonymous Function.
    acircle = @(t,y) [y(2); -y(1)];

%% ODE23 Automatic Plotting.
    figure
    tspan = [0 2*pi];
    y0 = [0; 1];
    ode23(acircle,tspan,y0)

%% Phase Plot.
    figure
    tspan = [0 2*pi];
    y0 = [0; 1];
    [t,y] = ode23(acircle,tspan,y0)
    plot(y(:,1),y(:,2),'-o')
    axis square
    axis([-1.1 1.1 -1.1 1.1])

%% ODE23 Automatic Phase Plot.
    opts = odeset('outputfcn',@odephas2)
    ode23(acircle,tspan,y0,opts)
    axis square
    axis([-1.1 1.1 -1.1 1.1])

%% ODE1 implements Euler's method.
% ODE1 illustrates the structure of the MATLAB ODE solvers,
% but it is low order and employs a coarse step size.
% So, even though the exact solution is periodic, the final value
% returned by ODE1 misses the initial value by a substantial amount.

    type ode1
    [t,y] = ode1(acircle,tspan,y0)
    err = y - y0

