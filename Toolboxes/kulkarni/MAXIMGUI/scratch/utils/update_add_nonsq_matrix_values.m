function update_add_nonsq_matrix_values(num_disp)

% Retrieves elements from matrix input boxes, updates global VValue matrix 

global NMValue NMHLabel_handle NMVLabel_handle NMValue_handle NMHLabel NMVLabel

%The displayed matrix rows(columns) are numbered from vindex(hindex) up
vindex = find(NMHLabel == str2num(get(NMHLabel_handle(1), 'String'))); 
hindex = find(NMVLabel == str2num(get(NMVLabel_handle(1), 'String'))); 
num_disp1=num_disp(1);
num_disp2 = num_disp(2);
for k = vindex:vindex+num_disp1-1
  for s = hindex:hindex+num_disp2-1
     ks = str2num(get(NMValue_handle(k-vindex+1,s-hindex+1), 'String')); 
     if (isempty(ks)) | size(ks,2) ~= 1
        NMValue(k,s) = Inf;
     else
        NMValue(k,s) = ks;
     end;
     
  end
end
