function mhscroll(num_disp)

global MValue MHLabel_handle MVLabel_handle MValue_handle MHLabel MVLabel

%step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;
[size1 size2] = size(MValue)
step = floor((size1-num_disp)*get(gcbo, 'Value')) ;
for k = 1:num_disp
   
   set(MHLabel_handle(k), 'String', MHLabel(k + step));
   for s=1:num_disp
  set(MValue_handle(s,k), 'String', MValue(s, k+step));
end
end
