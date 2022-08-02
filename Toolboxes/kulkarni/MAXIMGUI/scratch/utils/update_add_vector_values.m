function update_add_vector_values(vector_number, num_disp)

% Retrieves elements from vector input boxes, updates global AVValue matrix 

global AVValue AVLabel AVLabel_handle AVValue_handle vbase
% 0 = update all vectors in the matrix, otherwise update specified row
if vector_number == 0
  for k = 1:size(AVValue, 1)
    for n = 1:num_disp(k)
       j = str2num(get(AVLabel_handle(k,n), 'String'));
       jv=str2num(get(AVValue_handle(k,n), 'String'));
       if (isempty(jv) == 1) | size(jv,2) ~= 1
          AVValue(k, 1-vbase+j) = Inf;
       else
          AVValue(k, 1-vbase+j) = jv ;
       end;
       
          
    end
  end
else
      for n = 1:num_disp
      
      j = find(AVLabel == str2num(get(AVLabel_handle(vector_number,n), 'String')));
            jv=str2num(get(AVValue_handle(vector_number,n), 'String'));
      if (isempty(jv) == 1) | size(jv,2) ~= 1
         AVValue(vector_number, j) = Inf;
      else
         AVValue(vector_number, j) = jv ;
      end;

   end
end
