function save_new_model(rownum);
           % Capture file and path name
    [fname,pname] = uiputfile('*.*','SAVE AS') ;
    if (real(fname(1))==0 & real(pname(1))==0)
      return
   end
   outfile = [pname fname] ;
   switch rownum
   case 2
      load new_model_parameters.mat  new_model_title state_vector P n_trans ...
      init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
      dim=size(P,2);
      if isempty(init_dist)
         init_dist = zeros(1,dim);
      end
      if isempty(cost1)
         cost1 = zeros(1,dim);
      end
      if isempty(cost2)
         cost2 = zeros(dim,dim);
      end
 
      save(outfile,'rownum','new_model_title','state_vector','P', 'n_trans', ...
         'init_dist', 'n_occ_mat', 'n_cost', 'cost1', 'cost2', ...
         'number_of_targets', 'target_set');
   case 3
      load new_model_parameters.mat new_model_title state_vector P n_trans ...
      init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
      dim=size(P,2);
      if isempty(init_dist)
         init_dist = zeros(1,dim);
      end
      if isempty(cost1)
         cost1 = zeros(1,dim);
      end
      if isempty(cost2)
         cost2 = zeros(dim,dim);
      end

      save(outfile,'rownum','new_model_title','state_vector','P', 'n_trans', ...
         'init_dist', 'n_occ_mat', 'n_cost', 'cost1', 'cost2', ...
         'number_of_targets', 'target_set');
   case 4
      load new_model_parameters.mat new_model_title state_vector P w ...
      cost_rate lumpsum_cost;
      dim=size(P,2);
      if isempty(cost_rate)
         cost_rate = zeros(1,dim);
      end
      if isempty(lumpsum_cost)
         lumpsum_cost = zeros(1,dim);
      end

      save(outfile,'rownum','new_model_title','state_vector','P','w',...
         'cost_rate', 'lumpsum_cost');
   case 7
      load new_model_parameters.mat new_model_title state_vector ... 
         action_vector C W P;
      save(outfile,'rownum','new_model_title','state_vector',...
         'action_vector','C','W','P');
   end
