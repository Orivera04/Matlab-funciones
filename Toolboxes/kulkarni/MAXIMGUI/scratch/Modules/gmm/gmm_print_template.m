function gmm_print_template(fid)

% Outputs data from a Generalized Markov Model figure to a printable format
% Usage:  fid: file identifier (created as: fid = fopen(filename, option))

global Primary_state P fpt trans_dist longrun_cost state_vector cost_rate lumpsum_cost ...
   new_model_title

dim = size(P, 2) ;

% determine number of panels to print for matrices 
max_dim = 6 ;    % max col/row groupings per panel
num_panels = ceil(dim/max_dim) ;

% titles
fprintf(fid,'%s \n\n', '*************************************************');
model = get_primary_model ;
std_model = get_std_model_state(model)

if std_model == 0
   title = [Primary_state(model).model ' - ' new_model_title]
   else
title = [Primary_state(model).model ' - ' Primary_state(model).std_model_array{get_std_model_state(model)}] ;
end;
fprintf(fid, '%s \n\n', title) ;

%input parameters
if std_model ~= 0
% scalar parameters
m = size(Primary_state(model).scalar_parm{std_model}, 2); 
fprintf(fid,'%s \n\n','Parameters of the model:');
for k=1:m
   fprintf(fid,'%s %s %10.5f \n', Primary_state(model).scalar_label{std_model}{k},...
      ' =      ', str2num(Primary_state(model).scalar_parm{std_model}{k}));
end
end
fprintf(fid,'\n\n');
                      
switch std_model
case 1
   fprintf(fid,'%s \n','tau(i) = Mean Lifetime of Component i');
   fprintf(fid,'%s \n\n','r(i) = Mean Rep. Time of Component i');
   m=str2num(Primary_state(model).scalar_parm{std_model}{1});
   fprintf(fid,'%s %s %s \n\n','Comp. i   ','tau(i)    ','r(i)     ');
   for j=1:m
         fprintf(fid,'%i %s %9.3f %9.3f  \n',j,'   ',Primary_state(model).vector_matrix(1,j),...
         Primary_state(model).vector_matrix(2,j));

   end
   fprintf(fid,'\n\n');
end %end switch std_model


% transition matrix
if not(isempty(P))
   fprintf(fid,'%s \n\n', '*************************************************');

  fprintf(fid, 'Transition Matrix: \n\n') ;

      for panel_j = 1:num_panels

      % column labels
      fprintf(fid, '     ') ;
      for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
        fprintf(fid, '%10d', state_vector(j)) ;
        fprintf(fid, '%s', ' ') ;
      end
      fprintf(fid, '\n') ;

      % row label and transition matrix values
      for i = 1:dim
         fprintf(fid, '%4d %s', state_vector(i), ' ') ;
        for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
          fprintf(fid, '%10.8f', P(i,j)) ;
          fprintf(fid, '%s', ' ') ;
        end
        fprintf(fid, '\n') ;
      end

      fprintf(fid, '\n\n') ;
    end
  end

% sojourn time vector
if not(isempty(fpt))
  fprintf(fid,'%s \n\n', '*************************************************');
  fprintf(fid, 'Sojourn Time Vector: \n\n') ;
  fprintf(fid,'%s \n\n','w(i) = Mean Sojourn Time in State i');
  fprintf(fid, '%s %s \n\n', 'State i  ', '  w(i)');
  for i=1:dim
        fprintf(fid,'%3d %s %7.5f \n', state_vector(i), '        ', fpt(i));
     end;
     fprintf(fid,'\n\n'); 
  end

% Occupancy Distribution
if not(isempty(trans_dist))
  fprintf(fid,'%s \n\n', '*************************************************');
  fprintf(fid, 'Occupancy Distribution: \n\n') ;
  fprintf(fid,'%s \n\n','p(i) = Longrun Fraction of Time in State i');
  fprintf(fid, '%s %s \n\n', 'State i  ', '  w(i)');
  for i=1:dim
        fprintf(fid,'%3d %s %7.5f \n', state_vector(i), '        ', trans_dist(i));
     end;
     fprintf(fid,'\n\n'); 
  end

  
  % Long-Run Cost Rate
  if not(isempty(longrun_cost))
     fprintf(fid,'%s \n\n', '*************************************************');
     fprintf(fid, 'Cost Parameters: \n\n') ;

     fprintf(fid,'%s \n','c(i) = Cost rate of state i i');
     fprintf(fid,'%s \n\n','d(i) = Lump_sum Cost of Visiting State i');
     %m=str2num(Primary_state(model).scalar_parm{std_model}{1});
     fprintf(fid,'%s %s %s\n\n','Grade i   ','c(i)    ','d(i)     ');
     %for j=1:m+1
     for j=1:dim
         fprintf(fid,'%i %s %9.3f %9.3f  \n',state_vector(j),'   ',cost_rate(j),lumpsum_cost(j));

   end
   fprintf(fid,'\n\n');
fprintf(fid, 'Long-Run Cost Rate: \n\n') ;
    fprintf(fid, '%12.4f \n', longrun_cost) ;
  
end
    
    





