function [R, state_vector] = ct_rate_matrix (std_state, scalar, vector_matrix)

% Computes rate matrix for a Continuous Time Markov Model

switch std_state
  % General Machine Shop
  case 1
    R = ex6gms(scalar(4), scalar(3), scalar(2), scalar(1)) ; 
    state_vector = [0:scalar(2)] ;

  % Finite Capacity Single Server Queue
  case 2
    R = ex6ssq(scalar(3), scalar(2), scalar(1)) ; 
    state_vector = [0:scalar(1)] ;

  % Inventory Management
  case 3
    R = ex6inv(scalar(4), scalar(3), scalar(2), scalar(1))  
    state_vector = [0:scalar(2)+scalar(1)] ;

  % Finite Birth/Death Process
    case 4
    dim=size(vector_matrix,2);
    R = ex6fbd(vector_matrix(1, 1:dim-1), vector_matrix(2, 2:dim)) ;
    state_vector = [0:size(vector_matrix,2)] ;

  % Telephone Switch
  case 5
    R = ex6tel(scalar(3), scalar(2), scalar(1)) ; 
    state_vector = [0:scalar(1)] ;

  % Call Center
  case 6
    R = ex6cc(scalar(4), scalar(3), scalar(2), scalar(1)) ; 
    state_vector = [0:(scalar(1)+scalar(2))] ;

  % Manufacturing Systems
  case 7
    R = ex6mfg(scalar(4), scalar(3), scalar(2), scalar(1)) ; 
    state_vector = [0:2*scalar(1) - scalar(2)] ;

  % Airplane Reliability
  case 8
    R = ex6ar(scalar(1)) ;
    state_vector = [1:9] ;

  % Leaky Bucket
  case 9
    R = ex6lb(scalar(4), scalar(3), scalar(2), scalar(1)) ; 
    state_vector = [0:(scalar(1)+scalar(2))] ;

end  % switch std_state

