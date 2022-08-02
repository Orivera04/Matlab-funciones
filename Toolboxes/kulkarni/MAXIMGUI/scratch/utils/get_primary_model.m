function [rownum, state] = get_primary_model()

% function returns the first element in Primary_state with
% a non-zero state value

global Primary_state

% Pull all states out of the structure into a 1xdim matrix
[state_matrix] = [Primary_state.state] ;

% Determine which element is non-zero and return that row and its state
dim = size(state_matrix, 2) ;
rownum = 0 ;
for k = 1:dim
  if state_matrix(k) > 0
    rownum = k ;
    state = state_matrix(k) ;
    break ;
  end ; 
end ;

% else if we never find anything non-zero, display an error message and 
% then return the user to the main menu
%if rownum == 0
%  msg = {'ERROR! You must first select a primary Model' ...
%         'Return to the main menu and select a Model'} ;
%  err = errordlg(msg, 'ERROR') ;
%end ;