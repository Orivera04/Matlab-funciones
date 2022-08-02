function dd_example4_cbk1(drag,drop);
% DD_EXAMPLE4_CBK1      First callback for DD_EXAMPLE4.  Defines behavior for 2D Axes

str = get(drag,'string');
set(gcf,'CurrentAxes',drop);
L = feval(str);
plot(L)