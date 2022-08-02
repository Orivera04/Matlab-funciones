function valid_input_flag = validate_add_nonsq_matrix_parm(varname,matrix_input)

% VALIDATE MATRIX PARAMETER INPUT

global Scale Primary_state NMValue 
% Initialize valid input flag (1=input is valid, 0=invalid)
valid_input_flag = 1 ;
[matrix_size1 matrix_size2] = size(matrix_input);
% initialize a temporary scalar vector and message array for efficiency
% Retrieve the current (unvalidated) values of the Primary_state scalars
for i = 1:matrix_size1
   for j=1:matrix_size2
      if NMValue(i,j) == Inf
         valid_input_flag = 0 ;
         e= msgbox('Error! Expecting numeric input. Please try again.');
         uiwait(e);
         return;
      end;
   end;
end;
switch varname
   case 'W'
   if any(matrix_input <= 0)
      msg = 'Men sojourn times must be non-negative';
      valid_input_flag = 0;
   end;
end


  if valid_input_flag == 0 
     e = msgbox (msg, 'Matrix Input', 'error') ;
  uiwait(e)
  return ;
end ;

