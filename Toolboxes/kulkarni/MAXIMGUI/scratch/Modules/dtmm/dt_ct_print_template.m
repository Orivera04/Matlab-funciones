function dt_ct_print_template(fid)

% Outputs data from Discrete Time and Continuous Time Markov Model figures to a printable format
% Usage:  fid: file identifier (created as: fid = fopen(filename, option))

global Primary_state P trans_dist fpt occ_times lim_occ total_cost longrun_cost state_vector init_dist ...
cost_parameters cost_parameter_labels dist_called new_model_title

dim = size(P, 2) ;

% Determine number of panels to print for matrices 
max_dim = 6 ;    % max col/row groupings per panel
num_panels = ceil(dim/max_dim) ;

% Titles

fprintf(fid,'%s \n\n', '*************************************************');
model = get_primary_model; 
std_model = get_std_model_state(model);
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
%special parameters
fprintf(fid,'\n\n');
if (model == 2) & ((std_model == 3) | (std_model == 7))
   switch dist_called
      case 1
        par = str2num(char(Primary_state(model).distribution_parm{std_model}{1}));
        dist_label='Binomial';
        par_label = {'n', 'p'};
        m=2;
     case 4
        par = str2num(char(Primary_state(model).distribution_parm{std_model}{4}));
        dist_label='Geometric';
        par_label = {'p'};
        m=1;
     case 7
        par = str2num(char(Primary_state(model).distribution_parm{std_model}{7}));
        dist_label='Poisson';
        par_label = {'lambda'};
        m=1;
     case 8
        dist_label='discrete';
        m=size(Primary_state(model).vector_matrix,2);
        par_label=[0:m];
        par=Primary_state(model).vector_matrix

     end %end switch dist_called
     %print distribution parmeters
     if std_model==3
        rv_name = 'Demand';
     elseif std_model==7
        rv_name = 'Packet_arrival';
        end;
     fprintf(fid,'%s %s %s %s\n\n', rv_name,' distribution is ', dist_label,...
        ' with parameter(s) given below');
       if dist_called == 8
        fprintf(fid, '%s %s %s %s \n', '  i    ','P(', rv_name,' = i)');
        for j=1:m
         fprintf(fid,'%i %s %7.5f \n',par_label(j),'   ',par(j));
      end
     else
     for j=1:m
         fprintf(fid,'%s %s %7.5f \n',par_label{j},'   ',par(j));
end
end
elseif (model == 2) & (std_model == 5)
    %vector parameters
   fprintf(fid,'%s \n','p(i) = p(promotion from grade i to i+1)');
   fprintf(fid,'%s \n','l(i) = p(leaving from grade i)');
   fprintf(fid,'%s \n\n','a(i) = p(new employee enters grade i)');
   
   m=str2num(Primary_state(model).scalar_parm{std_model}{1});
   fprintf(fid,'%s %s %s %s \n\n','Grade i   ','p(i)    ','l(i)     ','a(i)');
   for j=1:m
         fprintf(fid,'%i %s %9.3f %9.3f %9.3f  \n',j,'   ',Primary_state(model).vector_matrix(1,j),...
         Primary_state(model).vector_matrix(2,j),...
         Primary_state(model).vector_matrix(3,j));

   end
elseif (model == 3) & (std_model == 4)
   fprintf(fid,'%s \n','lambda(i) = birth rate in state i');
   fprintf(fid,'%s \n\n','mu(i) = death rate in state i');
   m=str2num(Primary_state(model).scalar_parm{std_model}{1});
   fprintf(fid,'%s %s %s  \n\n','State i ','lambda(i) ','mu(i)     ');
   for j=0:m
         fprintf(fid,'%i %s %9.3f %9.3f   \n',j,'   ',Primary_state(model).vector_matrix(1,j+1),...
         Primary_state(model).vector_matrix(2,j+1));
end
end 
end
% Transition matrix
if not(isempty(P))
   fprintf(fid,'%s \n\n', '*************************************************');
if model == 2
   fprintf(fid, 'Transition Matrix: \n\n') ;
else
   fprintf(fid, 'Rate Matrix: \n\n') ;
end


  %for panel_i = 1:num_panels
    for panel_j = 1:num_panels

      % column labels
      fprintf(fid, '     ') ;
      for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
        fprintf(fid, '%10d', state_vector(j)) ;
        fprintf(fid, '%s', ' ') ;
      end
      fprintf(fid, '\n') ;

      % row label and transition matrix values
      %for i = (panel_i-1)*max_dim+1:min(panel_i*max_dim, dim)
      for i=1:dim   
        fprintf(fid, '%4d %s', state_vector(i), ' ') ;
        for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
          fprintf(fid, '%10.6f', P(i,j)) ;
          fprintf(fid, '%s', ' ') ;
        end
        fprintf(fid, '\n') ;
      end

      fprintf(fid, '\n\n') ;
    end
  %end
end

% Transient distribution
if not(isempty(trans_dist))
   fprintf(fid,'%s \n\n', '*************************************************');

   fprintf(fid, 'From initial distribution given below: \n\n');
   %print initial distribution
   if model == 2
   fprintf(fid, '%s %s \n\n', 'State i  ', '  P(X0=i)');
else
   fprintf(fid, '%s %s \n\n', 'State i  ', '  P(X(0)=i)');
end

         for i=1:dim
        fprintf(fid,'%3d %s %7.5f \n', state_vector(i), '        ', init_dist(i));
     end;
     
      fprintf(fid, '\n\n') ;
   
 trans_title = get(findobj('Tag', 'TransientDist'), 'String') ;

fprintf(fid, '%s \n\n',trans_title) ;

%print transient distribution
if model == 2
   fprintf(fid, '%s %s \n\n', 'State i  ', '  P(Xn=i)');
else
   fprintf(fid, '%s %s \n\n', 'State i  ', '  P(X(t)=i)');
end

  for i=1:dim
        fprintf(fid,'%3d %s %7.5f \n', state_vector(i), '        ', trans_dist(i));
     end;
fprintf(fid,'\n\n'); 
end

% First passage time vector
if not(isempty(fpt))
   fprintf(fid,'%s \n\n', '*************************************************');
   fpt_title=get(findobj('Tag', 'FPT'), 'String') ;


  fprintf(fid, '%s \n\n',fpt_title) ;
  fprintf(fid, '%s %s %s \n\n', 'Starting state', '   Mean of FPT', '     Var of  FPT'); 
  for i=1:dim
     fprintf(fid,'%s %3d %s %10.4f %s %12.4f \n','    ',state_vector(i),'      ',...
        fpt(i,2), '  ' , fpt(i,3));
     
         
  end
   fprintf(fid, '\n\n');

end

% Occupancy Times matrix
if not(isempty(occ_times))
   fprintf(fid,'%s \n\n', '*************************************************');

  occ_title=get(findobj('Tag', 'OccMatrix'), 'String') ;

  fprintf(fid, '%s \n\n',occ_title) ;

      for panel_j = 1:num_panels

      % column labels
      fprintf(fid, '     ') ;
      for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
        fprintf(fid, '%10d', state_vector(j)) ;
        fprintf(fid, '%s', ' ') ;
      end
      fprintf(fid, '\n') ;

      % row label and matrix values
      for i = 1:dim
         fprintf(fid, '%4d %s', state_vector(i), ' ') ;
        for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
          fprintf(fid, '%10.6f', occ_times(i,j)) ;
          fprintf(fid, '%s', ' ') ;
        end
        fprintf(fid, '\n') ;
      end

      fprintf(fid, '\n\n') ;
    end
 end

% Occupancy Distribution
if not(isempty(lim_occ))
   fprintf(fid,'%s \n\n', '*************************************************');

  fprintf(fid, 'Limiting/Occupancy Distribution: \n\n') ;
%print occupancy distribution
fprintf(fid, '%s %s \n\n', 'State i  ', '  P(X=i)');

  for i=1:dim
        fprintf(fid,'%3d %s %7.5f \n', state_vector(i), '        ',lim_occ(i));
     end;
fprintf(fid,'\n\n');
  end

% Total cost
if not(isempty(total_cost))|not(isempty(longrun_cost))
   fprintf(fid,'%s \n\n', '*************************************************');
    %print  cost parameters
   switch std_model
   case 0
      load new_model_parameters cost1 cost2
      fprintf(fid,'%s \n\n', 'c(i) = expected cost od visiting state i');
      fprintf(fid,'%s %s \n\n', 'State i  ','   c(i)   ');
      for j=1:dim
         fprintf(fid,'%i %9.3f \n', j, cost1(j));
      end;
      fprintf(fid,'\n\n');
      fprintf(fid,'%s \n\n', 'c(i,j) = expected cost of a transition from state i to j');
      for panel_j = 1:num_panels

      % column labels
      fprintf(fid, '     ') ;
      for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
        fprintf(fid, '%10d', state_vector(j)) ;
        fprintf(fid, '%s', ' ') ;
      end
      fprintf(fid, '\n') ;

      % row label and transition matrix values
      %for i = (panel_i-1)*max_dim+1:min(panel_i*max_dim, dim)
      for i=1:dim   
        fprintf(fid, '%4d %s', state_vector(i), ' ') ;
        for j = (panel_j-1)*max_dim+1:min(panel_j*max_dim, dim)
          fprintf(fid, '%10.6f', cost2(i,j)) ;
          fprintf(fid, '%s', ' ') ;
        end
        fprintf(fid, '\n') ;
      end

      fprintf(fid, '\n\n') ;
    end

      
   otherwise
      
   if (model == 2) & (std_model == 5)
      fprintf(fid,'%s \n','s(i) = Salary of an employee in grade i');
      fprintf(fid,'%s \n','b(i) = Bonus for promotion from grade i to i+1');
      fprintf(fid,'%s \n','d(i) = Cost of an employee departing from grade i');
      fprintf(fid,'%s \n\n','t(i) = Cost of training an employee starting in grade i');
   
   m=str2num(Primary_state(model).scalar_parm{std_model}{1});
   fprintf(fid,'%s %s %s %s %s\n\n','Grade i   ','s(i)    ','b(i)     ','d(i)    ','t(i)');
   for j=1:m
         fprintf(fid,'%i %s %9.3f %9.3f %9.3f %9.3f  \n',j,'   ',cost_parameters(1,j),...
         cost_parameters(2,j),...
         cost_parameters(3,j),cost_parameters(4,j));

   end
   fprintf(fid,'\n\n');
   
  else      
   for i=1:size(cost_parameters,2)
      fprintf(fid, '%s %s %10.5f \n\n', cost_parameter_labels{i},'=     ', cost_parameters(i));
   end
end
end
end
%print ETC
if not(isempty(total_cost))
totalcost_title=get(findobj('Tag', 'TotalCost'), 'String') ;

     fprintf(fid, '%s \n\n',totalcost_title) ;

fprintf(fid, '%s %s \n\n', 'State i  ', 'ETC(i)');

  for i=1:dim
        fprintf(fid,'%3d %s %7.5f \n', state_vector(i), '    ',total_cost(i,1));
     end;

 fprintf(fid, '\n\n')

  end

% Long-run Cost Rate
if not(isempty(longrun_cost))
   fprintf(fid,'%s \n\n', '*************************************************');

  fprintf(fid, 'Long-run Cost Rate: \n\n') ;
  fprintf(fid, '%12.4f', longrun_cost) ;
  fprintf(fid, '\n') ;
end

    





