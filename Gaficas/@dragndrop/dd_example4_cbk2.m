function dd_example4_cbk2(drag,drop);
% DD_EXAMPLE4_CBK2      Second callback for DD_EXAMPLE4.  Defines behavior for 3D Axes

str = get(drag,'string');
set(gcf,'CurrentAxes',drop);
L = feval(str);
surf(L);shading interp