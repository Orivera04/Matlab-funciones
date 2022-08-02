function valid_input_flag = validate_matrix_parameters(rownum, std_state, matrix_size)

% VALIDATE MATRIX PARAMETER INPUT

global Scale Primary_state MValue 
% Initialize valid input flag (1=input is valid, 0=invalid)
valid_input_flag = 1 ; 
% initialize a temporary scalar vector and message array for efficiency
% Retrieve the current (unvalidated) values of the Primary_state scalars
for i = 1:matrix_size
   for j=1:matrix_size
      if MValue(i,j) == Inf
         valid_input_flag = 0 ;
         e= msgbox('Error! Expecting numeric input. Please try again.');
         uiwait(e);
         return;
      end;
   end;
end;

% Validate numeric matrix input by model type - 
% NOTE: This section is sensitive to changes in ROWNUM and STD_STATE,
%       and changes in ordering of parameters in initialize_Primary_state 

switch (rownum)

       % Queueing Models   
   case 5   
     switch (std_state)
        
        % Jackson Network
     case 8
        if any(MValue < 0) | any( sum(MValue')> 1) | rank(MValue - eye(matrix_size)) ~= matrix_size
           msg(1) = {'The routing matrix must be substochastic and irreducible'};
           valid_input_flag = 0;
        else
        RM=Primary_state(rownum).matrix_matrix;
        s=Primary_state(rownum).vector_matrix(1,:);
        m=Primary_state(rownum).vector_matrix(2,:);
        l=Primary_state(rownum).vector_matrix(3,:);
        si = size(RM);
        a = l*inv(eye(si(2)) - RM);
        if any(a >= s.*m)
           msg(2)={'network is unstable'};
           valid_input_flag = 0;
        else
           Primary_state(rownum).vector_matrix(4,:)=a;
        end;
        
        end;
      
     end ; % switch std_state
   
  end ; % switch rownum

  if valid_input_flag == 0 
     e = msgbox (msg, 'Matrix Input', 'error') ;
  uiwait(e)
  return ;
end ;

