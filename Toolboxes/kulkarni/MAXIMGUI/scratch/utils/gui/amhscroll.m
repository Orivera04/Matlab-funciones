function amhscroll(num_disp)

global AMValue AMHLabel_handle AMVLabel_handle AMValue_handle AMHLabel AMVLabel
global stp1 stp2
%step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;
[size1 size2] = size(AMValue)
stp2 = floor((size1-num_disp)*get(gcbo, 'Value')) ;
for k = 1:num_disp
   
   set(AMHLabel_handle(k), 'String', AMHLabel(k + stp2));
   for s=1:num_disp
  set(AMValue_handle(s,k), 'String', AMValue(s+stp1, k+stp2));
end
end
