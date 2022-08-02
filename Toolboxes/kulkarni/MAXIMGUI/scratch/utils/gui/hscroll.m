function hscroll(vector_num, num_disp, vector_size)

global VLabel_handle VValue_handle VValue VLabel

%step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;

step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;
for k = 1:num_disp
  set(VLabel_handle(vector_num, k), 'String', VLabel(k + step))
  set(VValue_handle(vector_num, k), 'String', VValue(vector_num, k+step))
end


