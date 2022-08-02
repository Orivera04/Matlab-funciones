function update_matrix_values(num_disp)

% Retrieves elements from matrix input boxes, updates global VValue matrix 

global MValue MHLabel_handle MVLabel_handle MValue_handle MHLabel MVLabel

%The displayed matrix rows(columns) are numbered from vindex(hindex) up
vindex = str2num(get(MVLabel_handle(1), 'String')) ;
hindex = str2num(get(MHLabel_handle(1), 'String')) ;

for k = vindex:vindex+num_disp-1
  for s = hindex:hindex+num_disp-1
     ks = str2num(get(MValue_handle(k-vindex+1,s-hindex+1), 'String')) ;
     if (isempty(ks)) | size(ks,2) ~= 1
        MValue(k,s) = Inf;
     else
        MValue(k,s) = ks;
     end;
     
  end
end
