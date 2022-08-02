function valid_input_flag = validate_scalar_parameters(rownum, std_state, m)

% VALIDATE SCALAR PARAMETER INPUT

global Scale Primary_state

% Initialize valid input flag (1=input is valid, 0=invalid)
valid_input_flag = 1 ; 

% initialize a temporary scalar vector and message array for efficiency
scalar = zeros(1, m) ;

% Retrieve the current (unvalidated) values of the Primary_state scalars
for k = 1:m
  input = str2num(char(Primary_state(rownum).scalar_parm{std_state}(k))) ;
  if isempty(input) == 1
    valid_input_flag = 0 ;
    e = msgbox('Error! Expecting numeric input. Please try again.'); 
    uiwait(e)
    return
  else
    scalar(k) = input ;
  end
end;

% Validate numeric input by model type - 
% NOTE: This section is sensitive to changes in ROWNUM and STD_STATE,
%       and changes in ordering of parameters in initialize_Primary_state 

switch (rownum)

   % Probability Models
   case 1
     switch (std_state)
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
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'k must be a positive integer'};
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
    end ; % std_state

   % Discrete Time Markov Models   
   case 2
     switch (std_state)
       % Machine Reliability
       case 1
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'No. of Repairpersons must be a positive integer'};
           valid_input_flag = 0; 
         end ;
         if (scalar(2) <= 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(2) = {'No. of Machines must be a positive integer'};
           valid_input_flag = 0;
         end ;
         if (scalar(3) < 0) | (scalar(3) > 1)
           msg(3) = {'P(down|down) must be in [0,1]'};
           valid_input_flag=0;
         end ;
         if (scalar(4) < 0) | (scalar(4) > 1)
           msg(4) = {'P(up|up) must be in [0,1]'};
           valid_input_flag=0;   
         end ;

       % Note - no scalar parameters for Weather Models

       % Inventory System
       case 3
         if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0) | (scalar(1) < scalar(2))
           msg(1) = {'Restocking Level must be a positive integer greater than Basestock Level'};
           valid_input_flag = 0;
         end ;
         if (scalar(2) < 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(3) = {'Basestock Level must be a non-negative integer'};
           valid_input_flag = 0;
         end ;
   
       % Manufacturing
       case 4
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Size of Bin 1 must be a positive integer'};
           valid_input_flag = 0;
         end ;
         if (scalar(2) <= 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(2) = {'Size of Bin 2 must be a positive integer'};
           valid_input_flag = 0; 
         end ;
         if (scalar(3) < 0) | (scalar(3) > 1)
           msg(3) = {'P(No defect) Mach 1 must be in [0,1]'};
           valid_input_flag=0;
         end ;
         if (scalar(4) < 0) | (scalar(4) > 1)
           msg(4) = {'P(No defect) Mach 2 must be in [0,1]'};
           valid_input_flag=0;   
         end ;
   
       % Manpower Planning
       case 5
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'No. of Grades must be a positive integer'};
           valid_input_flag = 0;
         end ;

       % Stock Market
       case 6
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Upper Limit must be a positive integer'};
           valid_input_flag = 0;
         end ;
         if (scalar(2) < 0) | (fix(scalar(2)) - scalar(2) ~= 0) | (scalar(2) > scalar(1))
           msg(2) = {'Lower Limit must be a non-negative integer less than Upper Limit'};...
           valid_input_flag = 0; 
         end ;
   
       % Telecommunication
       case 7
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Buffer capacity must be a positive integer'};
           valid_input_flag = 0; 
         end ;
     end ; % std_state

   % Continuous Time Markov Models   
   case 3
     switch (std_state)
       % General Machine Shop
       case 1
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'No. of Repairpersons must be a positive integer'};
           valid_input_flag = 0;
         end ;
         if (scalar(2) <= 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(2) = {'No. of Machines must be a positive integer'}; 
           valid_input_flag = 0; 
         end ;
         if scalar(3) <= 0 
           msg(3) = {'Failure Rate must be positive'};
           valid_input_flag = 0;
         end ;
         if scalar(4) <= 0 
           msg(4) = {'Repair Rate must be positive'};
           valid_input_flag = 0;
         end ;

       % Finite Capacity Single Server Queue
       case 2   
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Capacity must be a positive integer'};
           valid_input_flag = 0; 
         end ;
         if scalar(2) <= 0 
           msg(2) = {'Service Rate must be positive'};
           valid_input_flag = 0;
         end ;
         if scalar(3) <= 0 
           msg(3) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
         end ;

       % Inventory System
       case 3
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Order Size must be a positive integer'};
           valid_input_flag = 0;
         end ;
         if (scalar(2) < 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(2) = {'Base Stock must be a positive integer'};
           valid_input_flag = 0; 
         end ;
         if scalar(3) <= 0 
           msg(3) = {'Demand Rate must be positive'}; 
           valid_input_flag = 0;
         end ;
         if scalar(4) <= 0 
           msg(4) = {'Delivery Rate must be positive'};
           valid_input_flag = 0;
         end ;

        % Finite Birth and Death Process  
        case 4
          if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
            msg(1) = {'No. of States must be a positive integer'};
            valid_input_flag = 0;
          end ;
      
        % Telephone Switch
        case 5
          if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
            msg(1) = {'Switch Capacity must be a positive integer'};
            valid_input_flag = 0; 
          end ;
          if scalar(2) <= 0 
            msg(2) = {'Call Completion Rate must be positive'};
            valid_input_flag = 0;
          end ;
          if scalar(3) <= 0 
            msg(3) = {'Call Arrival Rate must be positive'};
            valid_input_flag = 0;
          end ;

        % Call Center
        case 6
           if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0)
             msg(1) = {'Max. calls on hold must be a positive integer'};
             valid_input_flag = 0;
           end ;
           if (scalar(2) <= 0) | (fix(scalar(2)) - scalar(2) ~= 0)
             msg(2) = {'No. of agents must be a positive integer'};
             valid_input_flag = 0; 
           end ;
           if scalar(3) <= 0 
             msg(3) = {'Call service rate must be positive'};
             valid_input_flag = 0;
           end ;
           if scalar(4) <= 0 
             msg(4) = {'Call arrival rate must be positive'};
             valid_input_flag = 0;
           end ;

         % Manufacturing 
         case 7
           if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
             msg(1) = {'Storage Capacity must be a positive integer'};
             valid_input_flag = 0;
           end ;
           if (scalar(2) < 0) | (fix(scalar(2)) - scalar(2) ~= 0)
             msg(2) = {'Lower Control Limit must be a positive integer'};
             valid_input_flag = 0; 
           end ;
           if scalar(3) <= 0 
             msg(3) = {'Demand Rate must be positive'};
             valid_input_flag = 0;
           end ;
           if scalar(4) <= 0 
             msg(4) = {'Production Rate must be positive'};
             valid_input_flag = 0;
          end ;
          if scalar(2) >= scalar(1)
             msg(5) = {'Lower Control limit mut be les than the the capacity'};
             valid_input_flag = 0;
             end;

         % Airplane Reliability
         case 8
           if scalar(1) <= 0 
             msg(1) = {'Engine failure Rate must be positive'}; 
             valid_input_flag = 0;
           end ;
   
         % Leaky Bucket
         case 9
           if (scalar(1) < 0) | (fix(scalar(1)) - scalar(1) ~= 0)
             msg(1) = {'Token Pool Capacity must be a positive integer'};
             valid_input_flag = 0;
           end ;
           if (scalar(2) < 0) | (fix(scalar(2)) - scalar(2) ~= 0)
             msg(2) = {'Data Buffer Capacity  must be a positive integer'}; 
             valid_input_flag = 0; 
           end ;
           if scalar(3) <= 0 
             msg(3) = {'Token Generation Rate must be positive'}; 
             valid_input_flag = 0;
           end ;
           if scalar(4) <= 0 
             msg(4) = {'Packet Arrival Rate must be positive'};
             valid_input_flag = 0;
           end ;
     end ; % std_state

   % Generalized Markov Models   
   case 4
     switch (std_state)
       % Series System
       case 1
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'No. of Components must be a positive integer'};
           valid_input_flag = 0;
           end ;
     end ; % std_state
   
   % Queueing Models   
   case 5   
     switch (std_state)
       % M/M/1/K
       case 1
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Capacity must be a positive integer'};
           valid_input_flag = 0; 
           end ;
         if scalar(2) <= 0 
           msg(2) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(3) <= 0 
           msg(3) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
           end ;

       % M/M/s/K
       case 2 
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Capacity must be a positive integer'};
           valid_input_flag = 0; 
           end ;
         if (scalar(2) <= 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(2) = {'No. of Servers must be a positive integer'};
           valid_input_flag = 0; 
           end ;
         if scalar(3) <= 0 
           msg(3) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(4) <= 0 
           msg(4) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
           end ;

       % M/M/1 
       case 3
         if scalar(1) <= 0 
           msg(1) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(2) <= 0 
           msg(2) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
        end ;
        if scalar(1) <= scalar(2)
           msg(3) ={'The queue is unstable'};
           valid_input_flag = 0;
        end;
        

       % M/M/s
       case 4
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'No. of Servers must be a positive integer'};
           valid_input_flag = 0; 
           end ;
         if scalar(2) <= 0 
           msg(2) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(3) <= 0 
           msg(3) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
        end ;
        if scalar(1)*scalar(2) <= scalar(3)
           msg(4) = {'Queue is ustable'};
           valid_input_flag = 0;
           end;

       % M/M/infinity
       case 5
         if scalar(1) <= 0 
           msg(1) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(2) <= 0 
           msg(2) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
           end ;

       % M/G/1
       case 6
         if scalar(1) < 0 
           msg(1) = {'Var. Service Time  must be non-negative'};
           valid_input_flag = 0;
           end ;
         if scalar(2) <= 0 
           msg(2) = {'Mean Service Time must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(3) <= 0 
           msg(3) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(2)*scalar(3) > 1
           msg(4) = {'Queue is ustable'};
           valid_input_flag = 0;
           end;

       % G/M/1
       case 7
         if scalar(1) <= 0 
           msg(1) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
   
       % Jackson Network
       case 8
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'No. of Nodes must be a positive integer'};
           valid_input_flag = 0;
           end ;
     end ; % std_state
   
   % Design Models   
   case 6 
     switch (std_state)
       % Optimal Leasing of Phone Lines    
       case 1
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Max. No. of Lines must be a positive integer'};
           valid_input_flag = 0;
           end ;
         if scalar(4) <= 0 
           msg(2) = {'Call Completion Rate must be positive'};
           valid_input_flag = 0;
           end ;

       % Optimal Number of Tellers
       case 2 
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Capacity must be a positive integer'};
           valid_input_flag = 0;
           end ;
         if scalar(4) <= 0 
           msg(2) = {'Service Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(5) <= 0 
           msg(3) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
           end ;

       % Optimal Replacement
       case 3
         if scalar(1) < 0 | scalar(2) < 0 
           msg(1) = {'Replacement costs must be  non-negative'};
           valid_input_flag = 0;
           end ;
         if scalar(2) >= scalar(1)
           msg(2) = {'Unplanned rep cost must be  greater than planned rep cost'};
           valid_input_flag = 0; 
           end ;
           
       % Optimal Server Allocation   
       case 4
         if (scalar(1) <= 0) | (fix(scalar(1)) - scalar(1) ~= 0)
           msg(1) = {'Total No. of Servers must be a positive integer'};
           valid_input_flag = 0;
           end ;
         if scalar(2) <= 0 
           msg(2) = {'Service Rate 1 must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(3) <= 0 
           msg(3) = {'Service Rate 2 must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(4) <= 0 
           msg (4) = {'Arrival Rate must be positive'}; 
           valid_input_flag = 0;
           end ;
     end ; % std_state
   
   % Control Models   
   case 7
     switch (std_state)
       % Optimal Group Maintenance   
       case 1
         if (scalar(4) <= 0) | (fix(scalar(4)) - scalar(4) ~= 0)
           msg(1) = {'No. Of Machines must be a positive integer'};
           valid_input_flag = 0;
           end ;
         if (scalar(5) < 0) | (scalar(5) > 1)
           msg(2) = {'P(up|up) must be in [0,1]'};
           valid_input_flag = 0;
           end ;

       % Optimal Inventory Control
       case 2
         if scalar(1) <= 0 
           msg(1) = {'Expected Demand Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if (scalar(2) <= 0) | (fix(scalar(2)) - scalar(2) ~= 0)
           msg(2) = {'Storage Capacity must be a positive integer'};
           valid_input_flag = 0;
           end ;

       % Optimal Processor Scheduling
       case 3   
         if scalar(2) <= 0 
           msg(1) = {'Job Completion Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if scalar(3) <= 0 
           msg(2) = {'Arrival Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if (scalar(4) <= 0) | (fix(scalar(4)) - scalar(4) ~= 0)
           msg(3) = {'Capacity must be a positive integer'};
           valid_input_flag = 0;
           end ;
         if (scalar(5) <= 0) | (fix(scalar(5)) - scalar(5) ~= 0)
           msg(4) = {'Max. No. of Processors must be a positive integer'};
           valid_input_flag = 0;
           end ;

       % Optimal Machine Operation
       case 4   
         if scalar(3) <= 0 
           msg(1) = {'Demand Rate must be positive'} ; 
           valid_input_flag = 0;
           end ;
         if scalar(4) <= 0 
           msg(2) = {'Production Rate must be positive'};
           valid_input_flag = 0;
           end ;
         if (scalar(5) <= 0) | (fix(scalar(5)) - scalar(5) ~= 0)
           msg(3) = {'Capacity must be a positive integer'};
           valid_input_flag = 0;
           end ;
     end ; % std_state
end ; % switch rownum

if valid_input_flag == 0 
  e = msgbox (msg, 'Scalar Input', 'error') ;
  uiwait(e)
  return ;
end ;

