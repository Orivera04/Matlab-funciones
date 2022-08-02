function update_vector_values(vector_number, num_disp)

% Retrieves elements from vector input boxes, updates global VValue matrix 

global VValue VLabel VLabel_handle VValue_handle vbase
% 0 = update all vectors in the matrix, otherwise update specified row
if vector_number == 0
  for k = 1:size(VValue, 1)
    for n = 1:num_disp(k)
       j = str2num(get(VLabel_handle(k,n), 'String'));
       jv=str2num(get(VValue_handle(k,n), 'String'));
       if (isempty(jv) == 1) | size(jv,2) ~= 1
          VValue(k, 1-vbase+j) = Inf;
       else
          VValue(k, 1-vbase+j) = jv ;
       end;
       
          
    end
  end
else
   for n = 1:num_disp
      j = str2num(get(VLabel_handle(vector_number,n), 'String'));
            jv=str2num(get(VValue_handle(vector_number,n), 'String'));
      if (isempty(jv) == 1) | size(jv,2) ~= 1
         VValue(vector_number, 1-vbase+j) = Inf;
      else
         VValue(vector_number, 1-vbase+j) = jv ;
      end;

   end
end
