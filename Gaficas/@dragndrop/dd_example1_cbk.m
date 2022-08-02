function dd_example1_cbk(drag,drop)
% DD_EXAMPLE1_CBK  Callback function for dd_example1
disp(['You just dragged "' get(drag,'String') '" onto "' get(drop,'String') '"']);
