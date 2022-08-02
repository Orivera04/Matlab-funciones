function valid_input = new_model_input(rownum)

% INPUT PLATFORM FOR THE PARAMETERS OF A NEW MODEL INPUT


global Scale vbase Primary_state Next_process Last_process Current_process
% If this is not the correct procedure to be executing, return to caller
if strcmp(lower(Next_process), 'new_model_input') ~= 1
  return
else
   Current_process = 'new_model_input';
  Last_process = 'standard_load_create' ;
  Next_process = 'workbench' ;
end

% retrieve the labels of the currently seleted Primary and Standard model ;
model = Primary_state(rownum).model ;
primary_model = sprintf('New %s', model) ;
switch rownum
case 1 %probability models
   
   msgfig = msgbox('Create a New Model is not supported for probability models', 'Sorry!', 'help') ;
   uiwait(msgfig)
   Next_process = 'select_mode' ;
   valid_input=1;

case 2 %discrete time Markov models
   init_char='';
   new_model_title = add_char_input('Enter the name of the new discrete time Markov  model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   else
      valid_input = 1;
   end
   init_scalar = 0;
   number_of_states = add_scalar_input(new_model_title, 'Number_of_states',...
      'Specify the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

   vbase=1;
   init_v=[1:number_of_states];
        state_vector = add_vector_input(new_model_title, 'state_vector', 'Specify the state labels',...
         number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end

init_P=zeros(number_of_states,number_of_states);
         P = add_matrix_input(new_model_title, 'P', 'Specify the transition matrix P',...
         state_vector, number_of_states,init_P);
   if isempty(P) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

   if valid_input == 1
      n_trans =[];
      init_dist = [];
      n_occ_mat = [];
      n_cost = [];
      cost1=[];
      cost2 = [];
      number_of_targets = [];
      target_set = [];
      
      save new_model_parameters rownum new_model_title state_vector P n_trans ...
         init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
   end;
   
case 3 %continuous time markov models
   init_char='';
   new_model_title = add_char_input('Enter the name of the new continuous time Markov model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      else
      valid_input = 1;

   end
   init_scalar=0;
   number_of_states = add_scalar_input(new_model_title,...
      'Number_of_states', 'Specify the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_v = [1:number_of_states];
      vbase=1;
   state_vector = add_vector_input(new_model_title, 'state_vector',...
      'Specify the state labels',number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_P=zeros(number_of_states,number_of_states);

         P = add_matrix_input(new_model_title, 'R', 'Specify the rate matrix R',...
         state_vector, number_of_states,init_P);
   if isempty(P) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

      if valid_input == 1
         n_trans =[];
      init_dist = [];
      n_occ_mat = [];
      n_cost = [];
      cost1=[];
      cost2 = [];
      number_of_targets = [];
      target_set = [];

      save new_model_parameters new_model_title state_vector P n_trans ...
         init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
   end
   

case 4 %generalized markov models
   init_char = '';
   new_model_title = add_char_input('Enter the name of the new generalized Markov model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      else
      valid_input = 1;

   end
   init_scalar = 0;
   number_of_states = add_scalar_input(new_model_title,...
      'Number_of_states', 'Specify the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_v = [1:number_of_states];
     vbase=1;
   state_vector = add_vector_input(new_model_title, 'state_vector',...
      'Specify the state labels',number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_w=zeros(1,number_of_states);
   w = add_vector_input(new_model_title, 'sojourn_time_vector',...
      'Specfy the mean sojourn time in each state',...
      number_of_states,state_vector,init_w);
   if isempty(w) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_P=zeros(number_of_states,number_of_states);

   
      P = add_matrix_input(new_model_title, 'P', 'Specify the transition matrix P',...
         state_vector, number_of_states,init_P)
   if isempty(P) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

      if valid_input == 1
         cost_rate = [];
         lumpsum_cost = [];
      save new_model_parameters new_model_title state_vector P w cost_rate lumpsum_cost;
      
   end;
   
case 5 %queueing models 
   msgfig = msgbox('Create a New Model is not supported for queueing models', 'Sorry!', 'help') ;
   uiwait(msgfig)
   Next_process = 'select_mode' ;
   valid_input=1;
case 6 %design models 
   msgfig = msgbox('Create a New Model is not supported for design models', 'Sorry!', 'help') ;
   uiwait(msgfig)
   Next_process = 'select_mode' ;
   valid_input=1;
case 7 %control models 
   init_char = '';
   new_model_title = add_char_input('Enter the name of the new control model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      else
      valid_input = 1;

   end
   init_scalar = 0;
   number_of_states = add_scalar_input(new_model_title,...
      'Number_of_states', 'Specify the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_v = [1:number_of_states];
     vbase=1;
   state_vector = add_vector_input(new_model_title, 'state_vector',...
      'Specify the state labels',number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   init_scalar = 0;

   number_of_actions = add_scalar_input(new_model_title,...
      'Number_of_actions', ...
      'Specify the number of actions A',init_scalar);  
   if isempty(number_of_actions) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_v = [1:number_of_actions];
      vbase=1;
   action_vector = add_vector_input(new_model_title, 'action_vector',...
      'Specify the action labels',number_of_actions,[1:number_of_actions],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
     end

init_C=zeros(number_of_states,number_of_actions);

      C = add_nonsq_matrix_input(new_model_title, 'C',...
      'Specify the N X A cost matrix ',action_vector,state_vector,...
      [number_of_states number_of_actions],init_C);
   
   if isempty(C) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_W=ones(number_of_states,number_of_actions);

 W = add_nonsq_matrix_input(new_model_title, 'W',...
      'Specify the N X A sojourn-times matrix ',action_vector,state_vector,...
      [number_of_states number_of_actions],init_W);
   
   if isempty(W) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

P=[];   
for a=1:number_of_actions
   
   init_P = zeros(number_of_states,number_of_states);
        PP = add_matrix_input(new_model_title, 'P',...
         ['Specify the transition matrix for action ' num2str(a)],...
         state_vector, number_of_states,init_P);
           if isempty(PP) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
P=[P;PP];
end
if valid_input == 1
      save new_model_parameters new_model_title state_vector action_vector...
      C W P;
   end

end %end switch rownum
valid_input = 1;
