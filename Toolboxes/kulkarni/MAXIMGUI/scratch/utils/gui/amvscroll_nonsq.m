function amvscroll_nonsq(num_disp)

global NMValue NMHLabel_handle NMVLabel_handle NMValue_handle NMHLabel NMVLabel
global step1 step2
%step = floor((vector_size-num_disp)*get(gcbo, 'Value')) ;
[size1 size2] = size(NMValue);
num_disp1 = num_disp(1);
num_disp2 = num_disp(2);
step1 = floor((size1-num_disp1)*(1-get(gcbo, 'Value'))); 
for s = 1:num_disp1
   
   set(NMHLabel_handle(s), 'String', NMHLabel(s + step1));
   for k=1:num_disp2
  set(NMValue_handle(s,k), 'String', NMValue(s +step1, k+step2));
end
end
