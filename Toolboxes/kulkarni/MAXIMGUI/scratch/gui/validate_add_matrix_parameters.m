function valid_input = validate_add_matrix_parameters(varname, matrix_input)

% VALIDATE MATRIX PARAMETER INPUT

global Scale Primary_state AMValue 
% Initialize valid input flag (1=input is valid, 0=invalid)
valid_input = 1 ; 
% initialize a temporary scalar vector and message array for efficiency
% Retrieve the current (unvalidated) values of the Primary_state scalars
matrix_size = size(matrix_input,2);
for i = 1:matrix_size
   for j=1:matrix_size
      if AMValue(i,j) == Inf
         valid_input = 0 ;
         e= msgbox('Error! Expecting numeric input. Please try again.');
         uiwait(e);
         return;
      end;
   end;
end;

% Validate numeric matrix input by model type - 
% NOTE: This section is sensitive to changes in ROWNUM and STD_STATE,
%       and changes in ordering of parameters in initialize_Primary_state 
valid_input = 1;
switch varname
case 'P'
   if any(matrix_input < 0) | any(abs(sum(matrix_input') - 1) > .0000001)
      msg = 'Transititon matrix must be stochastic';
      valid_input = 0;
   end
   
case 'R'
   if any(matrix_input < 0) | any(diag(matrix_input) > 0)
      msg = 'Rate matrix must be non-negative, with zero diagonal entries';
      valid_input = 0;
   end
   
otherwise
   valid_input = 1;
    
end ; % switch rownum

  if valid_input == 0 
     e = msgbox (msg, 'Matrix Input', 'error') ;
  uiwait(e)
  return ;
end ;

