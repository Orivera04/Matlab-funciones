function dd_example3_cbk(drag,drop);
% DD_EXAMPLE3_CBK  Callback function for dd_example3
% Generates a plot of the type specified on a button dragged onto an axes.

str = get(drag,'string');
[x,y,z] = peaks;
feval(str,x,y,z);
shading interp