function get_vector_size(rownum, std_state)

%Get The SIZE OF THE VECTOR PARAMETERS 

global Scale Primary_state VValue VLabel vector_size...
    vbase 






% retrieve the number of vector inputs for the selected model
%m = size(Primary_state(rownum).vector_label{std_state}, 2) ;

%offset = (3 - m) * 0.1 ;
vector_present = 0;
% determine the required size of each vector
temp = rownum + 0.01*std_state ;
switch temp
  % Discrete Time Markov Models
  % Inventory Systems
  case 2.03
    size1 = str2num(char(Primary_state(rownum).distribution_parm{std_state}{8}{1})) ;
    size2 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))) ;
    size3 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(2))) ;
    vector_size = size1+1 ;
    vbase=0;vector_present = 1;
    % Manpower Planning
  case 2.05
    size1 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))) ;
    vector_size = [size1 size1 size1] ;
    vbase=1;
  vector_present = 1;

  % Telecommunications
  case 2.07
    size1 = str2num(char(Primary_state(rownum).distribution_parm{std_state}{8}{1})) ;
    size2 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))) ;
    vector_size = [size1+1] ;
    vbase=0;vector_present = 1;

  % Continuous Time Markov Models
  % Finite Birth and Death Process
  case 3.04
    size1 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))) + 1 ;
    vector_size = [size1 size1] ;
    vbase=0;vector_present = 1;
  % Generalized Markov Models
  case 4.01
    size1 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))) ;
    vector_size = [size1 size1] ;
    vbase=1;vector_present = 1;
    % Queueing Models
  case 5.07
     size1 = str2num(char(Primary_state(rownum).distribution_parm{std_state}{8}{1})) ;
     vector_size = size1 + 1;
     vbase=0;vector_present=1;
  case 5.08
    size1 = str2num(char(Primary_state(rownum).scalar_parm{std_state}(1))) ;
    vector_size = [size1 size1 size1] ;
    vbase=1;vector_present = 1;
    % Design Models
 case 6.03
    size1 = str2num(char(Primary_state(rownum).distribution_parm{std_state}{8}{1})) ;
     vector_size = size1 + 1;
     vbase=0;vector_present=1;
end  % switch temp
if vector_present == 1
   % initialize all vector values
   [m1 m] = size(vector_size);
  VValue = zeros(m, max(vector_size));
  VLabel = [vbase:max(vector_size)];
% Update the Primary_state structure with the new vectors
  Primary_state(rownum).vector_matrix = VValue;
end;