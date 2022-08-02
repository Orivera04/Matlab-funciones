function mhscroll(num_disp)

global MValue MHLabel_handle MVLabel_handle MValue_handle MHLabel MVLabel

%step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;
[size1 size2] = size(MValue)
step = floor((size2-num_disp)*(1-get(gcbo, 'Value'))) ;
for s = 1:num_disp
   
   set(MVLabel_handle(s), 'String', MVLabel(s + step));
   for k=1:num_disp
  set(MValue_handle(s,k), 'String', MValue(s +step, k));
end
end
