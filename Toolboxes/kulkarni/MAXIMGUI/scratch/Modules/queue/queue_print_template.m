function queue_print_template(fid)

% Outputs data from Queueing Model figures to a printable format
% Usage:  fid: file identifier (created as: fid = fopen(filename, option))

global Primary_state results dist_called node_id
queue_labels = {'Mean Number in System' 'Mean Number in Queue' 'Mean Waiting Time of Entering Customers'...
      'Mean Queueing Time  of Entering Customers' 'Mean Number of Busy Servers'...
      'Blocking Probability (System Full)' 'Probability of All Servers Busy'};

num_qpmf = results{8};
num_qpmfa = results{9};

dim = size(num_qpmf,1);

% Titles

fprintf(fid,'%s \n\n', '*************************************************');
model = get_primary_model;
std_model = get_std_model_state(model);
title = [Primary_state(model).model ' - ' Primary_state(model).std_model_array{get_std_model_state(model)}] ;
fprintf(fid, '%s \n\n', title) ;

%input parameters
% scalar parameters
m = size(Primary_state(model).scalar_parm{std_model}, 2); 
fprintf(fid,'%s \n\n','Parameters of the model:');
for k=1:m
   fprintf(fid,'%s %s %10.5f \n', Primary_state(model).scalar_label{std_model}{k},...
      ' =      ', str2num(Primary_state(model).scalar_parm{std_model}{k}));
end
%special parameters
fprintf(fid,'\n\n');
switch std_model
case 7
   switch dist_called
     case 3
        dist_label='Exponential';
        par_label={'lambda'};
        par = str2num(char(Primary_state(5).distribution_parm{std_model}{3}));
        m=1;
        l=par;
     case 2
        dist_label='Erlang';
        par_label={'k','lambda'};
        m=2;
        par = str2num(char(Primary_state(5).distribution_parm{std_model}{2}));
     case 4
        dist_label='Geometric';
        par_label = {'p'};
        m=1;
        par = str2num(char(Primary_state(5).distribution_parm{std_model}{4}));
     case 8
        dist_label='discrete';
        m=size(Primary_state(model).vector_matrix,2);
        par_label=[0:m];
        par=Primary_state(model).vector_matrix
     end %end switch
     %print distribution parmeters
     fprintf(fid,'%s %s %s\n\n', 'Inter-arrival distribution is ', dist_label,...
        ' with parameter(s) given below');
     if dist_called == 8
        fprintf(fid, '%s %s \n', '  i    ','P(Int.Arr.Time = i)');
        for j=1:m
         fprintf(fid,'%i %s %7.5f \n',par_label(j),'   ',par(j));
      end
     else
     for j=1:m
         fprintf(fid,'%s %s %7.5f \n',par_label{j},'   ',par(j));
      end
end
case 8
      %vector parameters
   fprintf(fid,'%s \n','lamda_i = external arrival rate at node i');
   fprintf(fid,'%s \n','mu_i = service rate at node i');
   fprintf(fid,'%s \n\n','s_i = number f servers at node i');
   
   m=str2num(Primary_state(model).scalar_parm{std_model}{1});
   fprintf(fid,'%s %s %s %s \n\n','Node i   ','lambda_i ','mu_i     ','s_i');
   for j=1:m
         fprintf(fid,'%i %s %9.3f %9.3f %9.3f  \n',j,'   ',Primary_state(model).vector_matrix(1,j),...
         Primary_state(model).vector_matrix(2,j),...
         Primary_state(model).vector_matrix(3,j));
   end
   %matrix parameters
   % Determine number of panels to print for matrices 
   max_dim = 6 ;    % max col/row groupings per panel
   num_panels = ceil(m/max_dim) ;
   P=Primary_state(model).matrix_matrix;
   fprintf(fid,'\n\n %s \n', 'Routing Matrix');
   for panel_j = 1:num_panels

      % column labels
      fprintf(fid, '     ') ;
      for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, m)
        fprintf(fid, '%10d', j) ;
        fprintf(fid, '%s', ' ') ;
      end
      fprintf(fid, '\n') ;

      % row label and routing matrix values
      for i=1:m   
        fprintf(fid, '%4d %s', i, ' ') ;
        for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, m)
          fprintf(fid, '%10.6f', P(i,j)) ;
          fprintf(fid, '%s', ' ') ;
        end
        fprintf(fid, '\n') ;
      end

      fprintf(fid, '\n\n %s %i \n\n', 'Output for Node ', node_id) ;
   end
end %end switch


%steady- state distributions
if ~isempty(num_qpmf)
 fprintf(fid,'%s \n\n', '*************************************************');

fprintf(fid, '%s \n\n','Steady State Distributions') ;
fprintf(fid, '%s %s \n\n','p(i) = ' ,'P(i customers in the system)') ;
fprintf(fid, '%s %s \n\n','p*(i) = ', 'P(incoming customer sees i in the system ahead)') ;

  fprintf(fid, '%s %s %s \n\n', '  State i', '      p(i) ', '     p*(i)'); 
  for i=1:dim
     fprintf(fid,'%s %3d %s %7.5f %s %7.5f \n','  ',num_qpmf(i,1),'      ',...
        sum(num_qpmf(1:i,2)), '  ' , sum(num_qpmfa(1:i,2)));
     
         
  end
   fprintf(fid, '\n\n');

end

%Performane vector
fprintf(fid,'%s \n\n', '*************************************************');

fprintf(fid, '%s \n\n','Steady State Performance Measures') ;

for i=1:7
         fprintf(fid, '%s %s %10.5f \n\n',queue_labels{i},'=     ', results{i});
   end
fprintf(fid,'%s \n\n', '*************************************************');
 
    





