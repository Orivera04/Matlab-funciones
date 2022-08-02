function valid_input_flag = validate_distribution_parameter(rownum, std_state, k,m)

% VALIDATE DISTRIBUTION PARAMETER INPUT

global Scale Primary_state Next_process Last_process

% Initialize valid input flag (1=input is valid, 0=invalid)
valid_input_flag = 1 ; 

% initialize a temporary scalar vector and message array for efficiency
scalar = zeros(1, m) ;

% Retrieve the current (unvalidated) values of the Primary_state dist parameters
for kk = 1:m
  input = str2num(char(Primary_state(rownum).distribution_parm{std_state}{k}(kk))) ;
  if isempty(input) == 1
    valid_input_flag = 0 ;
    e=msgbox('Error! Expecting numeric input. Please try again.');
    uiwait(e);
    return;
  else
    scalar(kk) = input ;
  end
end;

% Validate numeric input by distribution type - 

switch k

          % Binomial
       case 1
         if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'n must be a non-negative integer'} ;
           valid_input_flag = 0; 
         end ;
         if (scalar(2) < 0) | (scalar(2) > 1)
           msg(2) = {'p must satisfy 0 <= p <= 1'};
           valid_input_flag = 0;
         end ;

       % Erlang   
       case 2
         if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'k must be a non-negative integer'};
           valid_input_flag = 0;
         end ;
         if scalar(2) <= 0 
           msg(2) = {'lambda must be positive'};
           valid_input_flag = 0; 
         end ;
   
       % Exponential
       case 3
         if scalar(1) <= 0 
           msg(1) = {'lambda must be positive'};
           valid_input_flag = 0;    
         end ;

       % Geometric
       case 4
         if scalar(1) < 0 | scalar(1) > 1
           msg(1) = {'p must be in (0,1]'};
           valid_input_flag = 0;
         end ;
   
       % Negative Binomial
       case 5
         if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'r must be a non-negative integer'};
           valid_input_flag = 0;
         end ;
         if (scalar(2) < 0) | (scalar(2) > 1)
           msg(2) = {'p must be in [0,1]'};
           valid_input_flag = 0; 
         end ;

       % Normal
       case 6 
         if scalar(2) < 0 
           msg(1) = {'sigma must be non-negative'};
           valid_input_flag = 0; 
         end ;

       % Poisson
       case 7
         if scalar(1) < 0 
           msg(1) = {'lambda must be non-negative'};
           valid_input_flag = 0;    
        end ;
        
        %Discrete
        case 8
        if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'N must be a non-negative integer'};
           valid_input_flag = 0;
         end ;
 
      end ; % switch
  if valid_input_flag == 0 
  e = msgbox (msg, 'Distribution Input', 'error') ;
  uiwait(e)
  return ;
  end ;

