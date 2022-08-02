function valid_input_flag = validate_vector_parameters(rownum, std_state, vector_size)

% VALIDATE SCALAR PARAMETER INPUT

global Scale Primary_state VValue
% Initialize valid input flag (1=input is valid, 0=invalid)
valid_input_flag = 1 ; 
[m1 m]=size(vector_size);
% initialize a temporary scalar vector and message array for efficiency
% Retrieve the current (unvalidated) values of the Primary_state scalars
for k = 1:m
   %input = zeros(1,vector_size(k));
   for j=1:vector_size(k)
            if VValue(k,j) == Inf
               valid_input_flag = 0 ;
               e= msgbox('Error! Expecting numeric input. Please try again.');
    uiwait(e);
    return;
     else
    eval(['vector' num2str(k) '(' num2str(j) ')=VValue(' num2str(k) ',' num2str(j) ');']);
    
  end;
 end;
end;

% Validate numeric vector input by model type - 
% NOTE: This section is sensitive to changes in ROWNUM and STD_STATE,
%       and changes in ordering of parameters in initialize_Primary_state 

switch (rownum)

    % Discrete Time Markov Models   
   case 2
     switch (std_state)
        
       % Inventory System
       case 3
         if any(vector1 < 0) |  abs(sum(vector1)-1)>.00000001
           msg(1) = {'Demand pmf must be positive and add up to 1.'};
           valid_input_flag = 0;
         end ;
            
          
       % Manpower Planning
    case 5
         if any(vector1 < 0) | any(vector1 > 1)
           msg(1) = {'Promotion probabilities must be in [0,1].'};
           valid_input_flag = 0;
         end ;
         if any(vector2 < 0) | any(vector2 > 1)
           msg(2) = {'Departure probabilities must be in [0,1].'};
           valid_input_flag = 0;
         end ;
         if any(vector3 < 0) | abs(sum(vector3) - 1)> .00000001
           msg(3) = {'Joining probabilities must be in [0,1] and add up to 1.'};
           valid_input_flag = 0;
         end ;


       % Telecommunication
       case 7
         if any(vector1 < 0) |  abs(sum(vector1)-1)>.00000001
           msg(1) = {'Packet arrival pmf must be positive and add up to 1.'};
           valid_input_flag = 0;
         end ;
     end ; % std_state

   % Continuous Time Markov Models   
   case 3
     switch (std_state)
       
       
        % Finite Birth and Death Process  
        case 4
           if any(vector1(1:vector_size(1)-1) <= 0) 
              msg(1) = {'Birth rates must be nonnegative.'};
           valid_input_flag = 0;
        end ;
        if vector1(vector_size(1)) ~= 0
           msg(2) = {'Birth rate in last state must be zero.'};
           valid_input_flag = 0;
           end;
        if any(vector2(2:vector_size(2)) <= 0)
           msg(2) = {'Death rates must be nonnegative.'};
           valid_input_flag = 0;
        end ;
        if vector2(1) ~= 0
           msg(4) = {'Death rate in  state 0 must be zero.'};
           valid_input_flag = 0;
           end;
      end; %std-state
           
   % Generalized Markov Models   
   case 4
     switch (std_state)
       % Series System
       case 1
         if any(vector1 <= 0) 
              msg(1) = {'Mean lifetimes must be positive.'};
           valid_input_flag = 0;
        end ;
         if any(vector2 < 0) 
              msg(2) = {'Mean repairtimes must be positive.'};
           valid_input_flag = 0;
        end ;
     end ; % std_state
   
   % Queueing Models   
   case 5   
     switch (std_state)
        
       % Jackson Network
       case 8
       if any(vector1 <= 0) | any(fix(vector1)-vector1) ~= 0 
              msg(1) = {'Number of servers  must be positive integers.'};
           valid_input_flag = 0;
        end ;
       if any(vector2 <= 0) 
              msg(2) = {'Service rates must be positive.'};
           valid_input_flag = 0;
        end ;
       if any(vector3 < 0) 
              msg(3) = {'External arrival  rates must be nonnegative.'};
           valid_input_flag = 0;
        end ;
   
          
     end ; % std_state
   
  end ; % switch rownum

  if valid_input_flag == 0 
     e = msgbox (msg, 'Vector Input', 'error') ;
  uiwait(e)
  return ;
end ;

