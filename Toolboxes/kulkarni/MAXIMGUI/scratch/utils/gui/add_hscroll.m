function hscroll(vector_num, num_disp, vector_size)

global AVLabel_handle AVValue_handle AVValue AVLabel

%step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;

step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;
for k = 1:num_disp
  set(AVLabel_handle(vector_num, k), 'String', AVLabel(k + step));
  set(AVValue_handle(vector_num, k), 'String', AVValue(vector_num, k+step));
end


