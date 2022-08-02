function update_add_matrix_values(num_disp)

% Retrieves elements from matrix input boxes, updates global VValue matrix 

global AMValue AMHLabel_handle AMVLabel_handle AMValue_handle AMHLabel AMVLabel

%The displayed matrix rows(columns) are numbered from vindex(hindex) up
vindex = find(AMVLabel == str2num(get(AMVLabel_handle(1), 'String'))) ;
hindex = find(AMHLabel == str2num(get(AMHLabel_handle(1), 'String'))) ;

for k = vindex:vindex+num_disp-1
  for s = hindex:hindex+num_disp-1
     ks = str2num(get(AMValue_handle(k-vindex+1,s-hindex+1), 'String')) ;
     if (isempty(ks)) | size(ks,2) ~= 1
        AMValue(k,s) = Inf;
     else
        AMValue(k,s) = ks;
     end;
     
  end
end
