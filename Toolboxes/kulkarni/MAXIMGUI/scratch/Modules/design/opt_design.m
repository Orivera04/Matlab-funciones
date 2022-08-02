function [y,x,g] = opt_design(std_state, scalar,dist_called)

% Computes the optimal cost/revenue rate for the chosen design model
% Usage:  std_state: Standard Model chosen
%         scalar: vector of input scalars for the model selected
global Primary_state    

switch std_state
   % 'Optimal Leasing of Phone Lines'  
case 1
   
   [y,x,g] = ex8olpl(scalar(5),scalar(4),scalar(1),scalar(3),scalar(2));
   
     % 'Optimal Number of Tellers' 
  case 2
    [y,x,g] = ex8ont(scalar(5),scalar(4),scalar(3),scalar(2),scalar(1));

     %  'Optimal Replacement' 
  case 3
     switch dist_called
     case 2
        par = str2num(char(Primary_state(6).distribution_parm{std_state}{2}));
     case 8
        par = Primary_state(6).vector_matrix
     end %end switch
     [y,x,g] = ex8or(scalar(2),scalar(1)-scalar(2),dist_called,par);
  % 'Optimal Server Allocation'
  case 4
     [y,x,g] = ex8osa(scalar(4),[scalar(3),scalar(2)],scalar(1));

  
end  % switch std_state


