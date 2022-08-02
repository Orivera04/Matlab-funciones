function design_print_template(fid)

% Outputs data from a Generalized Markov Model figure to a printable format
% Usage:  fid: file identifier (created as: fid = fopen(filename, option))

global Primary_state design_results dist_called


% titles
fprintf(fid,'%s \n\n', '*************************************************');
model = get_primary_model ;
title = [Primary_state(model).model ' - ' Primary_state(model).std_model_array{get_std_model_state(model)}] ;
std_model = get_std_model_state(model);
fprintf(fid, '%s \n\n', title) ;

%input parameters
% scalar parameters
m = size(Primary_state(model).scalar_parm{std_model}, 2); 
fprintf(fid,'%s \n\n','Parameters of the model:');
for k=1:m
   fprintf(fid,'%s %s %10.5f \n', Primary_state(model).scalar_label{std_model}{k},...
      ' =      ', str2num(Primary_state(model).scalar_parm{std_model}{k}));
end
fprintf(fid,'\n\n');
                      
switch std_model
case 3
   switch dist_called
     case 2
        dist_label='Erlang';
        par_label={'k','lambda'};
        m=2;
        par = str2num(char(Primary_state(model).distribution_parm{std_model}{2}));
     case 8
        dist_label='discrete';
        m=size(Primary_state(model).vector_matrix,2);
        par_label=[0:m];
        par=Primary_state(model).vector_matrix
   end %end switch
     %print distribution parmeters
     fprintf(fid,'%s %s %s\n\n', 'Lifetime distribution is ', dist_label,...
        ' with parameter(s) given below');
     if dist_called == 8
        fprintf(fid, '%s %s \n', 'i    ','P(Lifetime = i)');
        for j=1:m
         fprintf(fid,'%i %s %7.5f \n',par_label(j),'   ',par(j));
      end
     else
     for j=1:m
         fprintf(fid,'%s %s %7.5f \n',par_label{j},'   ',par(j));
      end
end
   fprintf(fid,'\n\n');
end %end switch std_model
  
  % results
  if not(isempty(design_results))
     fprintf(fid,'%s \n\n', '*************************************************');
     fprintf(fid, '%s %12.4f \n\n','Optimal Parameter Value:     ', design_results(2)) ;
     fprintf(fid, '%s %12.4f \n\n','Optimal Objective Function:     ', design_results(1)) ;
  end
    
    





