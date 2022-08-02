function [P, state_vector] = dt_trans_matrix (std_state, scalar, vector_matrix)

% Computes transition probability matrix for the selected model
% Returns: P - transition probability matrix
%          state_vector - row vector of actual state values

switch std_state
  % Machine Reliability
  case 1
    P = ex5mr(scalar(4), scalar(3), scalar(2), scalar(1)) ;
    state_vector = [0:scalar(2)] ;

  % Weather Model
  case 2
    P = ex5wea ;
    state_vector = [1:size(P,1)] ;

  % Inventory Systems
  case 3
    P = ex5inv(scalar(2), scalar(1), vector_matrix(1,:)) ;
    state_vector = [scalar(2):scalar(1)] ;

  % Manufacturing Systems
  case 4
    P = ex5mfg(scalar(1), scalar(2), scalar(3), scalar(4)) ;
    state_vector = [0:(scalar(1)+scalar(2))] ;

  % Manpower Systems
  case 5
    P = ex5manp(vector_matrix(1,:), vector_matrix(2,:), vector_matrix(3,:)) ;
    state_vector = [1:size(vector_matrix,2)] ;

  % Stock Market
  case 6
    P = ex5stock(scalar(2), scalar(1)) ;
    state_vector = [scalar(2):scalar(1)] ;

  % Telecommunications
  case 7
    P = ex5tel(scalar(1), vector_matrix(1,:)) ;
    state_vector = [0:scalar(1)] ;

end  % switch std_state

