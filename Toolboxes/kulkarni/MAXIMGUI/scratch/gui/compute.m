function compute(rownum, std_state, workbench_item,dist_called)

% Executes the computation (as requested by Workbench) that is appropriate to
% the Primary and Standard Models selected

global Primary_state vbase node_id queue_results design_results opt_policy opt_value
global new_model_title

% The following are meant to be global only in a local sense - i.e. only insofar
% as we wish them to be visible to the display routines
global state_vector P trans_dist fpt occ_times lim_occ total_cost longrun_cost ...
       cost mean_var  opt_policy init_dist results cost_rate lumpsum_cost

% retrieve the labels of the currently selected Primary and Standard model ;
prim_model = Primary_state(rownum).model ;
if std_state <= 0
load new_model_parameters new_model_title state_vector P;
   std_model = new_model_title;
   else
      std_model = Primary_state(rownum).std_model_array{std_state} ;
end

title = sprintf('%s Model', std_model) ;

% retrieve scalars for std model
if std_state > 0
num_scalars = size(Primary_state(rownum).scalar_parm{std_state}, 2) ;
if num_scalars > 0
  for k = 1:num_scalars
    scalar(k) = str2num(char(Primary_state(rownum).scalar_parm{std_state}(k))) ;
  end
else
  scalar = [] ;
end
else
   scalar =[];
end

switch rownum ;
  % Probability Models
  case 1
    switch workbench_item
      % Mean / Variance
      case 1
         mean_var = [mean_variance(std_state, scalar)] ;
         num_cdf=[];
         num_pmf=[];
        prob_output(prim_model, title, mean_var, num_cdf, num_pmf) ; 
        
      % CDF and  PMF/PDF
      case 2
        mean_var = [mean_variance(std_state, scalar)] ;
        num_cdf = [cdf(std_state, scalar)] ;
        num_pmf = [pmf(std_state, scalar)] ;
        prob_output(prim_model, title, mean_var, num_cdf, num_pmf) ;     
        
      % Plot CDF
      case 3
        cdf_plot(prim_model, title, std_state, scalar) ;
        
      % Plot PMF/PDF
      case 4
        pmf_plot(prim_model, title, std_state, scalar) ;

    end ; % switch workbench_item

  % Discrete Time Markov Models
  case 2
     if std_state > 0
        vector_matrix = Primary_state(rownum).vector_matrix ;
     switch dist_called
     case 1
        par = str2num(char(Primary_state(rownum).distribution_parm{std_state}{1}));
        v = pmf(dist_called,par);
        vector_matrix = v(:,2)'
     case 4
        par = str2num(char(Primary_state(rownum).distribution_parm{std_state}{4}));
        v = pmf(dist_called,par);
        vector_matrix = v(:,2)' 
     case 7
        par = str2num(char(Primary_state(rownum).distribution_parm{std_state}{7}));
        v = pmf(dist_called,par);
        vector_matrix = v(:,2)';
     end
     
        
             
    % Compute transition matrix and build state_vector (to keep track of actual states
    % rather than just the index)
           
        [P, state_vector] = dt_trans_matrix(std_state, scalar, vector_matrix) ;
    
    end
    dim = size(P, 1);
    if std_state == -1
       load new_model_parameters.mat  new_model_title state_vector P n_trans ...
          init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
    else
       n_trans = 0;
       init_dist = zeros(1,dim);
       n_occ_mat = 0;
       n_cost = 0;
       cost1 = zeros(1,dim);
       cost2 = zeros(dim,dim);
       number_of_targets = 0;
       target_set = [];
   end

    switch workbench_item
      % Transition Matrix
      case 1
        % display main figure if not yet invoked
        if isempty(findobj('Tag', 'DT_CT_Output'))
          dt_ct_output(prim_model, rownum,title, dim) ;
        end
        % output state labels and matrix values
        for r = 1:dim
          set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          for c = 1:dim
            set(findobj('Tag', 'TransMatrixValue', 'UserData', [r,c]), 'String', sprintf('%10.8f', P(r,c))) ;
          end
        end 

      % Transient Distribution
      case 2
        % Prompt user for initial distribution and n
        % Compute transient distribution and display
        init_scalar = n_trans;
        n = add_scalar_input(prim_model, 'n',...
           'Specify n for the distribution of Xn',init_scalar) ; 
           if isempty(n)
              return
           end
                   
           vbase=state_vector(1);
              init_d=init_dist;
                            init_dist = add_vector_input(prim_model, 'init_dist',...
                 'Specify the Initial Distribution', size(P, 2), state_vector,init_d) ;
              if isempty(init_dist)
                 return
              end
              
              if std_state <= 0
                 n_trans = n;
                 save new_model_parameters n_trans init_dist -append 
              end
              
                  trans_dist = dtmctd(init_dist, P, n) ;

            % create a string to pass in as a label
            label_string = sprintf('Trans. Dist. for n=%d', n) ;

            % display main form if not yet invoked
            if isempty(findobj('Tag', 'DT_CT_Output'))
              dt_ct_output(prim_model,rownum, title, dim) ;
            end

            % add state labels if necessary
            if isempty(get(findobj('Tag', 'TransColLabel', 'UserData', [1]), 'String'))
              for r = 1:dim
                set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
                set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
              end
            end
          
            % update label and value objects
            set(findobj('Tag', 'TransientDist'), 'String', label_string) ;
            for c = 1:dim
              set(findobj('Tag', 'TransDistValue', 'UserData', [c]), 'String', sprintf('%6.4f', trans_dist(c))) ;
            end
            
            % Occupancy Times
         case 3
            init_scalar = n_occ_mat;
                          n = add_scalar_input(prim_model, 'n', 'Specify time n',init_scalar) ;
               if isempty(n)
                     return
                  end
                  
                  if std_state <= 0
                 n_occ_mat = n;
                 save new_model_parameters n_occ_mat -append 
              end

                           occ_times = dtmcot(P, n) ;

          % create a string to pass in as a label
          label_string = sprintf('Occupancy Matrix for n=%d', n) ;

          % display form if not yet invoked and update label
          if isempty(findobj('Tag', 'DT_CT_Output'))
            dt_ct_output(prim_model,rownum, title, dim) ;
          end
          set(findobj('Tag', 'OccMatrix'), 'String', label_string) ;

          % output state labels and matrix values
          for r = 1:dim
            set(findobj('Tag', 'OccColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            set(findobj('Tag', 'OccRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            for c = 1:dim
              set(findobj('Tag', 'OccMatrixValue', 'UserData', [r,c]), 'String', sprintf('%10.8f', occ_times(r,c))) ;
            end
          end 
           
      % Limiting and Occupancy Distribution
      case 4
        lim_occ = dtmcod(P) ;

        % display form if not yet invoked
        if isempty(findobj('Tag', 'DT_CT_Output'))
          dt_ct_output(prim_model,rownum, title, dim) ;
        end

        % add state labels if necessary
        if isempty(get(findobj('Tag', 'OccColLabel', 'UserData', [1]), 'String'))
          for r = 1:dim
            set(findobj('Tag', 'OccColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            set(findobj('Tag', 'OccRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          end
        end
          
        % update values
        for c = 1:dim
          set(findobj('Tag', 'OccDistValue', 'UserData', [c]), 'String', sprintf('%10.8f', lim_occ(c))) ;
        end

      % Cost Models
      case 5
        % No cost model for Weather or Stock Market
        if (std_state == 2 | std_state == 6)
          msgfig = msgbox('This function not supported for the model selected', 'Help', 'help') ;
          uiwait(msgfig)
        else
          cost_type = generic_menu(prim_model, 'Select a Cost Model', {'Total Cost' 'Long-Run Cost Rate' 'Cancel'}) ;
          if not(isempty(cost_type))
             if cost_type == 3
                return
                end
             if std_state <= 0
                init_c = cost1;
                cost1 = add_vector_input(prim_model, 'cost',...
                   'Specify the expected cost of visiting state i', dim, [],init_c); 
                if isempty(cost1)
                   return;
                end
                init_c = cost2;
                cost2 = add_matrix_input(prim_model, 'cost',...
                   'Specify the expected cost of transititon from state i to j',...
                   state_vector,dim,init_c) ; 
                if isempty(cost2)
                   return;
                end

                cost = cost1' + diag(P*cost2');
                save new_model_parameters cost1 cost2  -append
             
             else
                cost = dt_cost(std_state, state_vector, scalar, vector_matrix) ;
             end
             
            if not(isempty(cost))
               
              switch cost_type
                case 1
                   % Total Cost
                   init_scalar=n_cost;
                   n = add_scalar_input(prim_model, 'n',...
                      'For Total Expected Cost, specify time n',init_scalar) ;
                  if isempty(n)
                     return
                  end
                  if std_state <= 0
                     n_cost = n;
                     save new_model_parameters n_cost -append;
                  end;
                  
                                    total_cost = dtmctc(P, cost, n) ;
                  % display form if not yet invoked
                  if isempty(findobj('Tag', 'DT_CT_Output'))
                    dt_ct_output(prim_model, rownum,title, dim) ;
                  end

                  % create a string to pass in as a label
                  label_string = sprintf('Exp. Total Cost Upto n=%d', n) ;
                  set(findobj('Tag', 'TotalCost'), 'String', label_string) ;

                  % add state labels if necessary
                  if isempty(get(findobj('Tag', 'OccRowLabel', 'UserData', [1]), 'String'))
                    for r = 1:dim
                      set(findobj('Tag', 'OccRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
                    end
                  end

                  for r = 1:dim
                    set(findobj('Tag', 'MeanCostValue', 'UserData', [r]), 'String', total_cost(r, 1)) ;
                    end
                case 2
                  % Long-run Cost Rate
                  longrun_cost = dtmclrc(P, cost) ;

                  % display form if not yet invoked
                  if isempty(findobj('Tag', 'DT_CT_Output'))
                    dt_ct_output(prim_model,rownum, title, dim) ;
                  end

                  set(findobj('Tag', 'LongRunCostValue'), 'String', longrun_cost) ;
              end   % switch
            end  % if not(isempty(cost))
          end  % if not(isempty(cost_type))
        end  % else

      % First Passage Times
   case 6
      old_number = number_of_targets;
      init_scalar = number_of_targets;
      number_of_targets = add_scalar_input(prim_model,...
         'number_of_targets', 'Specify number of target states',init_scalar); 
        if isempty(number_of_targets)
           return
        end
        number_of_targets = min(number_of_targets,dim);
        vbase=1;
        if number_of_targets == old_number
           init_t = target_set;
        else
           init_t = zeros(1,number_of_targets);
        end;
        
        target_set = add_vector_input(prim_model, 'target_set',...
                   'Specify the set of target states', number_of_targets, [1:number_of_targets],init_t) ;
          if isempty(target_set)
             return
          end
          if std_state <= 0
             save new_model_parameters number_of_targets target_set -append;
             end;
                    % convert the target_set from states to actual vector indices (in case these are not the same)
         for k_ = 1:size(target_set, 2)
            target_seti(k_) = find(state_vector == target_set(k_)) ;
         end
        
                    first_passage = dtmcfpt(target_seti, P) ;

            % output from dtmcfpt does not include the target states - pad the output with zeros for display
            fpt = [state_vector', zeros(size(state_vector,2),2)] ;
            for i_ = 1:size(first_passage,1)
               fpt(first_passage(i_,1), 2) = first_passage(i_, 2) ;
               fpt(first_passage(i_,1), 3) = first_passage(i_, 3) ;

            end

            % create a string to pass in as a label
            label_string = ['First Passage Time into {'] ;
            for k = 1:size(target_set,2)
              label_string = [label_string sprintf('%i', target_set(k)) ','] ;
            end 
            label_string(size(label_string,2)) = '}'; 
 
            % display form if not yet invoked and update label
            if isempty(findobj('Tag', 'DT_CT_Output'))
              dt_ct_output(prim_model, rownum,title, dim) ;
            end
            set(findobj('Tag', 'FPT'), 'String', label_string) ;

            % add state labels if necessary
            if isempty(get(findobj('Tag', 'TransRowLabel', 'UserData', [1]), 'String'))
              for r = 1:dim
                set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
                set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
              end
            end
          
            % update values
            for r = 1:dim
               set(findobj('Tag', 'MeanFPTValue', 'UserData', [r]), 'String', sprintf('%f', fpt(r,2))) ;
               set(findobj('Tag', 'VarFPTValue', 'UserData', [r]), 'String', sprintf('%f', fpt(r,3))) ;
            end

              end ; % switch workbench_item

  % Continuous Time Markov Models
  case 3
    if std_state > 0
    vector_matrix = Primary_state(rownum).vector_matrix ;

    % Compute rate matrix (Using P instead of R for consistency with DTMM routines)
    [P, state_vector] = ct_rate_matrix(std_state, scalar, vector_matrix) ;
    end;
    dim=size(P,2);
    if std_state == -1
       load new_model_parameters.mat  new_model_title state_vector P n_trans ...
          init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
    else
       n_trans = 0;
       init_dist = zeros(1,dim);
       n_occ_mat = 0;
       n_cost = 0;
       cost1 = zeros(1,dim);
       cost2 = zeros(dim,dim);
       number_of_targets = 0;
       target_set = [];
   end

    switch workbench_item
      % Rate Matrix
      case 1
        % display main figure if not yet invoked
        if isempty(findobj('Tag', 'DT_CT_Output'))
          dt_ct_output(prim_model, rownum,title, dim) ;
        end
        % output state labels and matrix values
        for r = 1:dim
          set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          for c = 1:dim
            set(findobj('Tag', 'TransMatrixValue', 'UserData', [r,c]), 'String', sprintf('%10.8f', P(r,c))) ;
          end
        end 

      % Transient Distribution
      case 2
         % Prompt user for time and initial distribution
        init_scalar = n_trans;           
        ct_time = add_scalar_input(prim_model, 'ct_time',...
           'To compute the pmf of X(t) specify time t (>0)',init_scalar) ;
        if isempty(ct_time)
           return
        end
        vbase = state_vector(1);
        init_d = init_dist;
        init_dist = add_vector_input(prim_model, 'init_dist', ...
        'Specify the initial distribution', size(P, 2), state_vector,init_d); 
        if isempty(init_d)
           return
        end
        if std_state <= 0
           n_trans = ct_time;
           save new_model_parameters n_trans init_d -append;
        end;
        trans_dist = ctmctd(init_dist, P, ct_time) ;

            % create a string to pass in as a label
            label_string = sprintf('Trans. Dist. for t=%d', ct_time) ;

            % display form if not yet invoked
            if isempty(findobj('Tag', 'DT_CT_Output'))
              dt_ct_output(prim_model, rownum,title, dim) ;
            end

            % add state labels if necessary
            if isempty(get(findobj('Tag', 'TransColLabel', 'UserData', [1]), 'String'))
              for r = 1:dim
                set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
                set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
              end
            end
          
            % update label and values
            set(findobj('Tag', 'TransientDist'), 'String', label_string) ;
            for c = 1:dim
              set(findobj('Tag', 'TransDistValue', 'UserData', [c]), 'String', sprintf('%10.8f', trans_dist(c))) ;
            end
               % Occupancy Times Distribution
      case 3
         % Prompt user for time
         init_scalar = n_occ_mat;
         ct_time = add_scalar_input(prim_model, 'ct_time', 'Specify time (>0)',init_scalar) ;
            if isempty(ct_time)
               return
            end
            if std_state <= 0
             n_occ_mat = ct_time;
             save new_model_parameters n_occ_mat -append;
             end;
                                  occ_times = ctmcom(P, ct_time) ;  

          % create a string to pass in as a label
          label_string = sprintf('Occ. Matrix for t=%d', ct_time) ;

          % display form if not yet invoked and update label
          if isempty(findobj('Tag', 'DT_CT_Output'))
            dt_ct_output(prim_model,rownum, title, dim) ;
          end
          set(findobj('Tag', 'OccMatrix'), 'String', label_string) ;

          % output state labels and matrix values
          for r = 1:dim
            set(findobj('Tag', 'OccColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            set(findobj('Tag', 'OccRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            for c = 1:dim
              set(findobj('Tag', 'OccMatrixValue', 'UserData', [r,c]), 'String', sprintf('%10.8f', occ_times(r,c))) ;
            end
          end 
        
      % Limiting and Occupancy Distributions
      case 4
        lim_occ = ctmcod(P) ;

        % display form if not yet invoked
        if isempty(findobj('Tag', 'DT_CT_Output'))
          dt_ct_output(prim_model,rownum, title, dim) ;
        end

        % add state labels if necessary
        if isempty(get(findobj('Tag', 'OccColLabel', 'UserData', [1]), 'String'))
          for r = 1:dim
            set(findobj('Tag', 'OccColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            set(findobj('Tag', 'OccRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          end
        end
          
        % update values
        for c = 1:dim
          set(findobj('Tag', 'OccDistValue', 'UserData', [c]), 'String', sprintf('%10.8f', lim_occ(c))) ;
        end

      % Cost Models
      case 5
        % No cost model for Birth/Death, Airline Reliability, or Leaky Bucket
        if (std_state == 4 | std_state == 8 | std_state == 9)
          msgfig = msgbox('This function not supported for the model selected', 'Help', 'help') ;
          uiwait(msgfig)
        else
          cost_type = generic_menu(prim_model, 'Select a Cost Model', {'Total Cost' 'Long-Run Cost Rate' 'Cancel'}) ;
          if not(isempty(cost_type))
             if cost_type == 3
                return
                end

             %if isempty(cost)
             if std_state <= 0
                init_c = cost1;
                cost1 = add_vector_input(prim_model, 'cost',...
                   'Specify the cost rate in state i', dim, [],init_c) ;
                if isempty(cost1)
                   return;
                end
                init_c = cost2;
                cost2 = add_matrix_input(prim_model, 'cost',...
                   'Specify the expected lumpsum cost of transititon from state i to j',...
                   state_vector,dim,init_c);  
                if isempty(cost2)
                   return;
                end
                cost = cost1' + diag(P*cost2');
                save new_model_parameters cost1 cost2  -append;
             else
                cost = ct_cost(std_state, scalar, vector_matrix) ;
             end
                      
            if not(isempty(cost))
              switch cost_type
                case 1
                   % Total Cost
                  init_scalar = n_cost; 
                  n = add_scalar_input(prim_model, 'n', ...
                     'For Total Expected Cost, specify time t',init_scalar) ;
                  if isempty(n)
                     return
                  end
                  if std_state <= 0
                     n_cost = n;
             save new_model_parameters n_cost -append;
             end;
                  total_cost = ctmctc(P, cost, n) ;

                  % display form if not yet invoked
                  if isempty(findobj('Tag', 'DT_CT_Output'))
                    dt_ct_output(prim_model,rownum, title, dim) ;
                 end
                 
                 % create a string to pass in as a label
                  label_string = sprintf('Exp. Total Cost Upto t=%d', n) ;
                  set(findobj('Tag', 'TotalCost'), 'String', label_string) ;


                  % add state labels if necessary
                  if isempty(get(findobj('Tag', 'OccRowLabel', 'UserData', [1]), 'String'))
                    for r = 1:dim
                      set(findobj('Tag', 'OccRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
                    end
                  end

                  for r = 1:dim
                    set(findobj('Tag', 'MeanCostValue', 'UserData', [r]), 'String', total_cost(r, 1)) ;
                    end
                case 2
                  % Long-run Cost Rate
                  longrun_cost = ctmclrc(P, cost) ;
  
                  % display form if not yet invoked
                  if isempty(findobj('Tag', 'DT_CT_Output'))
                    dt_ct_output(prim_model,rownum, title, dim) ;
                  end

                  set(findobj('Tag', 'LongRunCostValue'), 'String', longrun_cost) ;
              end  % switch 
            end % if not(isempty(cost))
          end  % if not(isempty(cost_type))
        end  % else

      % First Passage Times
   case 6
      old_number = number_of_targets;
      init_scalar = number_of_targets;
      number_of_targets = add_scalar_input(prim_model,...
         'number_of_targets', 'Specify number of target states',init_scalar) ;
      if (isempty(number_of_targets) ~= 1)
         number_of_targets = min(number_of_targets,dim);
           vbase = 1;
           if number_of_targets == old_number
           init_t = target_set;
        else
           init_t = zeros(1,number_of_targets);
        end;

           target_set = add_vector_input(prim_model, 'target_set',...
              'Specify the set of target states', number_of_targets, [],init_t) ;
          % convert the target_set from states to actual vector indices (in case these are not the same)
          for k_ = 1:size(target_set, 2)
             find(state_vector == target_set(k_))
            target_seti(k_) = find(state_vector == target_set(k_)) ;
          end

          if not(isempty(target_set))
             if std_state <= 0
             save new_model_parameters number_of_targets target_set -append;
             end;
            first_passage = ctmcfpt(target_seti, P) ;

            % output from ctmcfpt does not include the target states - pad the output with zeros for display
            fpt = [state_vector', zeros(size(state_vector,2),1)] ;
            for i_ = 1:size(first_passage,1)
               fpt(first_passage(i_,1), 2) = first_passage(i_, 2) ;
               fpt(first_passage(i_,1), 3) = first_passage(i_, 3) ;
            end
        
            % create a string to pass in as a label
            label_string = ['First Passage Time into {'] ;
            for k = 1:size(target_set,2)
              label_string = [label_string sprintf('%d', target_set(k)) ','] ;
            end 
            label_string(size(label_string,2)) = '}' ;
 
            % display form if not yet invoked and update label
            if isempty(findobj('Tag', 'DT_CT_Output'))
              dt_ct_output(prim_model,rownum, title, dim) ;
            end
            set(findobj('Tag', 'FPT'), 'String', label_string) ;

            % add state labels if necessary
            if isempty(get(findobj('Tag', 'TransRowLabel', 'UserData', [1]), 'String'))
              for r = 1:dim
                set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
                set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
              end
            end
          
            % update values
            for r = 1:dim
               set(findobj('Tag', 'MeanFPTValue', 'UserData', [r]), 'String', sprintf('%f', fpt(r,2))) ;
               set(findobj('Tag', 'VarFPTValue', 'UserData', [r]), 'String', sprintf('%f', fpt(r,3))) ;
            end

          end ; % if not(isempty)
        end ; % if (isempty)


    end ; % switch workbench_item

  % Generalized Markov Models
  case 4

    
    % Transition Probability Matrix and Sojourn Time Vector
    % Note: sojourn time vector is being named fpt in order to be consistent
    %       with the utilities shared by DTMM and CTMM
    if std_state > 0
       vector_matrix = Primary_state(rownum).vector_matrix ;
       [P, fpt] = ex7ser(scalar(1), vector_matrix(1,:)', vector_matrix(2,:)') ;
       state_vector = [0:scalar(1)] ;
    else
       load new_model_parameters w;
       fpt=w';
    end
    
    
    dim = size(P, 2) ;
    if std_state == -1
       load new_model_parameters.mat  cost_rate lumpsum_cost;

    else
       cost_rate = zeros(1,dim);
       lumpsum_cost = zeros(1,dim);
       end


    switch workbench_item
      % Transition Matrix
      case 1

        % display form if not yet invoked
        if isempty(findobj('Tag', 'GMM_Output'))
          gmm_output(prim_model, title, size(state_vector, 2)) ;
        end

        % output state labels and matrix values
        for r = 1:dim
          set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          for c = 1:dim
            set(findobj('Tag', 'TransMatrixValue', 'UserData', [r,c]), 'String', sprintf('%10.8f', P(r,c))) ;
          end
        end 

      % Sojourn Time Vector
      case 2

        % display form if not yet invoked
        if isempty(findobj('Tag', 'GMM_Output'))
          gmm_output(prim_model, title, size(state_vector, 2)) ;
        end

        % add state labels if necessary
        if isempty(get(findobj('Tag', 'TransRowLabel', 'UserData', [1]), 'String'))
          for r = 1:dim
            set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          end
        end
          
        % update values
        for r = 1:dim
          set(findobj('Tag', 'FPTValue', 'UserData', [r]), 'String', sprintf('%f', fpt(r))) ;
        end

      % Limiting/Occupancy Distribution
      case 3

        % Note: trans_dist is being used instead of lim_occ in order to
        %       reuse the scrolling utilities developed for DTMM/CTMM
        trans_dist = smpod(P, fpt) ;

        % display form if not yet invoked
        if isempty(findobj('Tag', 'GMM_Output'))
          gmm_output(prim_model, title, size(state_vector, 2)) ;
        end

        % add state labels if necessary
        if isempty(get(findobj('Tag', 'TransColLabel', 'UserData', [1]), 'String'))
          for r = 1:dim
            set(findobj('Tag', 'TransColLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
            set(findobj('Tag', 'TransRowLabel', 'UserData', [r]), 'String', sprintf('%d', state_vector(r))) ;
          end
        end
          
        % update label and values
        for c = 1:dim
          set(findobj('Tag', 'TransDistValue', 'UserData', [c]), 'String', sprintf('%10.8f', trans_dist(c))) ;
        end

      % Cost Models
      case 4

         % Prompt user for input of cost rates and lumpsum costs of the i-th element
         vbase = state_vector(1);
         init_c = cost_rate;
         cost_rate = add_vector_input(prim_model, 'cost_rate',...
            'Specify the cost rate of the i-th state', dim, state_vector,init_c) ;
        if isempty(cost_rate)
           return;
        end
        
        init_c = lumpsum_cost;
        lumpsum_cost = add_vector_input(prim_model, 'lumpsum_cost', ...
        'Specify the lumpsum cost for visiting the i-th state', dim, state_vector,init_c) ;
        if isempty(lumpsum_cost)
           return
        end
        if std_state <= 0
             save new_model_parameters cost_rate lumpsum_cost -append;
             end;

        % Compute long-run cost rate
        longrun_cost = smplrc(P, fpt, cost_rate', lumpsum_cost') ;

        % display form if not yet invoked
        if isempty(findobj('Tag', 'GMM_Output'))
          gmm_output(prim_model, title, size(state_vector, 2)) ;
        end

        % update value
        set(findobj('Tag', 'LongRunCostValue'), 'String', sprintf('%12.4f', longrun_cost)) ;

    end  %switch workbench_item

  % Queueing Models
  case 5

     % Collect all results for a particular model in one cell_array
     
          
     results = compute_queue(dist_called,std_state, scalar);
     if isempty(results)
        return;
     end
     
    title = sprintf('%s Model: Node %i', std_model, node_id) ;
    switch workbench_item
      % Rate Matrix
      case 1
        % display main figure if not yet invoked
        if isempty(findobj('Tag', 'Queue_Output'))
          queue_output(prim_model, title, results) ;
        end
     end  %switch workbench_item
     
  % Design 
  case 6
     par_name={'Number of Phone Lines','Number of Tellers','Replacement Time', ...
           'Control Limit'};
     % compute the optimal cost/revenue rate
     [y,x,g] = opt_design(std_state,scalar,dist_called);
     design_results=y;
     switch workbench_item
      % Numerical Results
      case 1

     if isempty(findobj('Tag','designfig'))
        design_output(std_model, par_name{std_state}, y(2),y(1));
     end
  case 2
      if isempty(findobj('Tag','plotfig'))
        design_plot(std_model, par_name{std_state},x,g);
     end
end %end switch

  % Control
case 7
   switch workbench_item
   case 1
      [I,g] = opt_control(std_state,scalar,1);
      [m1 m2]=size(I);
      add_nonsq_matrix_input('Control Output',...
         'cost matrix', 'This is the cost matrix:',g(1:m2),g(m2+1:m1+m2),size(I),I);
      
   case 2
      [I,g] = opt_control(std_state,scalar,2);
      if isempty(I)
         return
      end
      [m1 m2]=size(I);
      add_matrix_input('Control Output',...
         'trans matrix', sprintf('This is the Tran. Prob. matrix P(%i):',g(m2+1)),...
         g(1:m2),size(I,2),I);
      
   case 3 
      [I,g] = opt_control(std_state,scalar,3);
      [m1 m2]=size(I);
      add_nonsq_matrix_input('Control Output',...
         'sojourn matrix', 'This is the Sojourn Times Matrix W:',g(1:m2),g(m2+1:m1+m2),size(I),I);
  
   case 4
      [I,g] = opt_control(std_state,scalar,4);
   opt_policy = I;
   opt_value = g;
   for i=1:size(I,2)
   if I(i) == -1
      e=msgbox(sprintf('Action in state %i may be inaccurate or undefined',state_vector(i)));
      uiwait(e);
   end;
end

   if isempty(findobj('Tag','controlfig'))
        control_output(std_model,I,g);
     end
     end %switch


end ; % switch rownum
