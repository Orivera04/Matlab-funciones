function design_print_template(fid)

% Outputs data from a Generalized Markov Model figure to a printable format
% Usage:  fid: file identifier (created as: fid = fopen(filename, option))

global Primary_state opt_policy opt_value state_vector

% titles
fprintf(fid,'%s \n\n', '*************************************************');
model = get_primary_model ;
title = [Primary_state(model).model ' - ' Primary_state(model).std_model_array{get_std_model_state(model)}] ;
std_model = get_std_model_state(model);
fprintf(fid, '%s \n\n', title) ;
dim = size(opt_policy,2);
%input parameters
% scalar parameters
m = size(Primary_state(model).scalar_parm{std_model}, 2); 
fprintf(fid,'%s \n\n','Parameters of the model:');
for k=1:m
   fprintf(fid,'%s %s %10.5f \n', Primary_state(model).scalar_label{std_model}{k},...
      ' =      ', str2num(Primary_state(model).scalar_parm{std_model}{k}));
end
fprintf(fid,'\n\n');
                      
  % results
  if not(isempty(opt_policy))
     fprintf(fid,'%s \n\n', '*************************************************');
     fprintf(fid, '%s %12.4f \n\n','Optimal Objective Value:     ', opt_value) ;
     fprintf(fid,'%s \n\n', '*************************************************');
     fprintf(fid, '%s \n\n','Optimal Policy:') ;
     fprintf(fid, '%s %s \n\n','a*(i) = ' ,'Optimal action in state i') ;
     fprintf(fid, '%s %s  \n\n', '  State i', '  a*(i) '); 
     for i=1:dim
        fprintf(fid,'%s %3d %s %i  \n','  ',state_vector(i),'      ',opt_policy(i));
     end
     fprintf(fid, '\n\n');
  end

      
    





