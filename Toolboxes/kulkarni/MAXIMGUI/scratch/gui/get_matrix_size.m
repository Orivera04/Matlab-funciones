function  get_matrix_size(rownum, std_state)
%Get the sizes of the appropriate input matrices
global  Primary_state MValue matrix_size
% retrieve the size  of matrix input
temp = rownum + 0.01*std_state ;
switch temp
  % Queueing Models
  % Jackson Networks
   case 5.08
   size1 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))); 
   matrix_size = [size1];
   %Initialize the Matrix Entries
   MValue = zeros(size1,size1) ;
   % Update the Primary_state structure with the new vector
   Primary_state(rownum).matrix_matrix = MValue;
end  % switch temp
