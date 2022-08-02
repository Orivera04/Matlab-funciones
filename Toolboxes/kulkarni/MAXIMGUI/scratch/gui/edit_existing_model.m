function valid_input = edit_existing_model(model_class);
global Scale vbase Primary_state Next_process Last_process Current_process

% If this is not the correct procedure to be executing, return to caller
if strcmp(lower(Next_process), 'edit_existing_model') ~= 1
  return
else
   Current_process = 'edit_existing_model';
  Last_process = 'standard_load_create' ;
  Next_process = 'workbench' ;
end

global cancel_win





switch model_class
      
   case 1 %probability models
   
   msgfig = msgbox('Select Model from a File is not supported for probability models', 'Sorry!', 'help') ;
   uiwait(msgfig)
   Next_process = 'select_mode' ;
   valid_input=1;
   
   case 5 %queueing models
   
   msgfig = msgbox('Select Model from a File is not supported for queueing models', 'Sorry!', 'help') ;
   uiwait(msgfig)
   Next_process = 'select_mode' ;
   valid_input=1;

   case 6 %design models
   
   msgfig = msgbox('Select Model from a File is not supported for design models', 'Sorry!', 'help') ;
   uiwait(msgfig)
   Next_process = 'select_mode' ;
   valid_input=1;

   otherwise %other models
     
    
    valid_file = 0;
    while (valid_file == 0)
       [fname pname] = uigetfile('*.*','LOAD MODEL FROM FILE'); 
       if (real(fname(1))==0 | real(pname(1))==0)
          Next_process = 'select_mode';
          valid_input = 1; return; %to exit the loop
       else
          infile = [pname fname]; 
          load(infile,'rownum');
          if rownum ~= model_class
             valid_file = 0;
             e = msgbox('File Incompatible with the Model Selected. Please try again');
             uiwait(e);
          else 
             valid_file = 1;
          end
       end
       
    end
    
    char_input = 'DO you wish to VIEW or EDIT the current model specifications?';
cancel_win = 0 ;
% display main figure
charfig = figure('Name', 'Edit/View', ...
                  'NumberTitle','off', ...
                  'Units','normalized', ...
                  'Color',[0.76 0.76 0.76], ...
                  'Position',[.3 .3 .3 .3], ...
                  'Menubar','none',...
                  'Tag','ScalarInputFig');

% display labels
uicontrol('Parent',charfig, ...
          'Units','normalized', ...
          'Position',[.05 .7 .9 .3], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize', Scale*15, ...
          'HorizontalAlignment','left',...
          'String', sprintf('%s :', char_input)) ;


% Add action buttons
uicontrol('Parent',charfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', 'uiresume(gcbf)',...
          'FontName','time roman', ...
          'Fontsize',Scale*14, ...
          'Position',[.3 .05 .20 .15], ...
          'String','YES') ;
       
uicontrol('Parent',charfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', ['set_cancel;uiresume(gcbf);'],...
          'FontName','time roman', ...
          'Fontsize',Scale*14, ...
	       'Position',[.55 .05 .30 .15], ...
          'String','NO', ...
          'Tag', 'Cancel') ;

       uiwait(charfig) 
       
              
   
close(charfig) ;




   valid_input = 0;
   switch rownum
   case 2
      load(infile,'rownum','new_model_title','state_vector','P', 'n_trans', ...
         'init_dist', 'n_occ_mat', 'n_cost', 'cost1', 'cost2', ...
         'number_of_targets', 'target_set');
      if cancel_win == 0
      init_char=new_model_title;
      new_model_title = add_char_input('Edit the name of the new discrete time Markov  model',init_char);
      if isempty(new_model_title) 
          Next_process = 'select_mode';
          valid_input = 1;return;
      else
          valid_input = 1;
      end
   init_scalar = size(P,2);
   number_of_states = add_scalar_input(new_model_title, 'Number_of_states',...
      'Edit the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   if number_of_states > size(P,2)
      new_state_vector = [state_vector zeros(1,number_of_states-size(P,2))];
      new_P=zeros(number_of_states,number_of_states);
      new_P(1:size(P,2),1:size(P,2))=P;
      init_dist = [init_dist zeros(1,number_of_states-size(P,2))]; 
      cost1 = [cost1 zeros(1,number_of_states-size(P,2))];
      new_cost2 = zeros(number_of_states,number_of_states);
      new_cost2(1:size(P,2),1:size(P,2))=cost2;
      cost2=new_cost2;
      elseif number_of_states < size(P,2)
         new_state_vector = state_vector(1:number_of_states);
         new_P=P(1:number_of_states,1:number_of_states);
         init_dist = init_dist(1:number_of_states);
         cost1 = cost1(1:number_of_states);
         cost2 = cost2(1:number_of_states,1:number_of_states);
      else
         new_state_vector = state_vector;
         new_P = P;
   end;
   
   
   init_v=new_state_vector;
        state_vector = add_vector_input(new_model_title, 'state_vector', 'Edit the state labels',...
         number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end

   init_P=new_P;
   P = add_matrix_input(new_model_title, 'P', 'Edit the transition matrix P',...
         state_vector, number_of_states,init_P);
   if isempty(P) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
else
   valid_input = 1;
end



   if valid_input == 1
      save new_model_parameters.mat  new_model_title state_vector P n_trans ...
         init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
   end
   
   case 3
      load(infile,'rownum','new_model_title','state_vector','P', 'n_trans', ...
         'init_dist', 'n_occ_mat', 'n_cost', 'cost1', 'cost2', ...
         'number_of_targets', 'target_set');
      if cancel_win == 0
      init_char=new_model_title;
   new_model_title = add_char_input('Edit the name of the new continuous time Markov model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      else
      valid_input = 1;

   end
   init_scalar=size(P,2);
   number_of_states = add_scalar_input(new_model_title,...
      'Number_of_states', 'Edit the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   if number_of_states > size(P,2)
      new_state_vector = [state_vector zeros(1,number_of_states-size(P,2))];
      new_P=zeros(number_of_states,number_of_states);
      new_P(1:size(P,2),1:size(P,2))=P;
      init_dist = [init_dist zeros(1,number_of_states-size(P,2))]; 
      cost1 = [cost1 zeros(1,number_of_states-size(P,2))];
      new_cost2 = zeros(number_of_states,number_of_states);
      new_cost2(1:size(P,2),1:size(P,2))=cost2;
      cost2=new_cost2;
      elseif number_of_states < size(P,2)
         new_state_vector = state_vector(1:number_of_states);
         new_P=P(1:number_of_states,1:number_of_states);
         init_dist = init_dist(1:number_of_states);
         cost1 = cost1(1:number_of_states);
         cost2 = cost2(1:number_of_states,1:number_of_states);
      else
         new_state_vector = state_vector;
         new_P = P;
   end;
   
   init_v=new_state_vector;
      vbase=1;
   state_vector = add_vector_input(new_model_title, 'state_vector',...
      'Edit the state labels',number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_P=new_P;

         P = add_matrix_input(new_model_title, 'R', 'Edit the rate matrix R',...
         state_vector, number_of_states,init_P);
   if isempty(P) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   
else
   valid_input = 1;
end


if valid_input == 1
      save new_model_parameters.mat new_model_title state_vector P n_trans ...
         init_dist n_occ_mat n_cost cost1 cost2 number_of_targets target_set;
   end
   
   case 4
      load(infile,'rownum','new_model_title','state_vector','P','w',...
         'cost_rate', 'lumpsum_cost');
      
      if cancel_win == 0
         
      init_char = new_model_title;
   new_model_title = add_char_input('Edit the name of the new generalized Markov model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      else
      valid_input = 1;

   end
   init_scalar = size(P,2);
   number_of_states = add_scalar_input(new_model_title,...
      'Number_of_states', 'Edit the number of states N',init_scalar);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   if number_of_states > size(P,2)
      new_w = [w zeros(1,number_of_states-size(P,2))];
      new_state_vector = [state_vector zeros(1,number_of_states-size(P,2))];
      new_P=zeros(number_of_states,number_of_states);
      new_P(1:size(P,2),1:size(P,2))=P;
      cost_rate = [cost_rate zeros(1,number_of_states-size(P,2))];
      lumpsum_cost = [lumpsum_cost zeros(1,number_of_states-size(P,2))];
   elseif number_of_states < size(P,2)
      new_w= w(1:number_of_states);
         new_state_vector = state_vector(1:number_of_states);
         new_P=P(1:number_of_states,1:number_of_states);
         cost_rate = cost_rate(1:number_of_states);
         lumpsum_cost = lumpsum_cost(1:number_of_states);
      else
         new_state_vector = state_vector;
         new_P=P;
         new_w=w;
   end;
   
   init_v=new_state_vector;

     vbase=1;
   state_vector = add_vector_input(new_model_title, 'state_vector',...
      'Edit the state labels',number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_w=new_w;
   w = add_vector_input(new_model_title, 'sojourn_time_vector',...
      'Edit the mean sojourn time in each state',...
      number_of_states,state_vector,init_w);
   if isempty(w) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end

init_P=new_P;

   
      P = add_matrix_input(new_model_title, 'P', 'Edit the transition matrix P',...
         state_vector, number_of_states,init_P);
   if isempty(P) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   
else
   valid_input = 1;
end



if valid_input == 1
      save new_model_parameters.mat new_model_title state_vector P w ...
         cost_rate lumpsum_cost;
   end
   
   case 7  %control models
      load(infile,'rownum','new_model_title','state_vector',...
         'action_vector','C','W','P');
      
      if cancel_win == 0
         
      init_char = new_model_title;
   new_model_title = add_char_input('Edit the name of the new control model',init_char);
   if isempty(new_model_title) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      else
      valid_input = 1;

   end
   original_nos = size(C,1);
   number_of_states = add_scalar_input(new_model_title,...
      'Number_of_states', 'Edit the number of states N',original_nos);  
   if isempty(number_of_states) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   init_v = zeros(1,number_of_states);
   init_v(1:min(number_of_states,original_nos)) = state_vector(1:min(number_of_states,original_nos));
     vbase=1;
   state_vector = add_vector_input(new_model_title, 'state_vector',...
      'Edit the state labels',number_of_states,[1:number_of_states],init_v);
   if isempty(state_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   original_noa = size(C,2);

   number_of_actions = add_scalar_input(new_model_title,...
      'Number_of_actions', ...
      'Edit the number of actions A',original_noa);  
   if isempty(number_of_actions) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end
init_v = zeros(1,number_of_actions)
   init_v(1:min(number_of_actions,original_noa)) = action_vector(1:min(number_of_actions,original_noa));
      vbase=1;
   action_vector = add_vector_input(new_model_title, 'action_vector',...
      'Edit the action labels',number_of_actions,[1:number_of_actions],init_v);
   if isempty(action_vector) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
   
   init_C = zeros(number_of_states,number_of_actions);
   init_C(1:min(number_of_states,original_nos),1:min(number_of_actions,original_noa))...
      =C(1:min(number_of_states,original_nos),1:min(number_of_actions,original_noa));

      C = add_nonsq_matrix_input(new_model_title, 'C',...
      'Edit the N X A cost matrix ',action_vector,state_vector,...
      [number_of_states number_of_actions],init_C);
   
   if isempty(C) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end
init_W = zeros(number_of_states,number_of_actions);
   init_W(1:min(number_of_states,original_nos),1:min(number_of_actions,original_noa))...
      =W(1:min(number_of_states,original_nos),1:min(number_of_actions,original_noa));

 W = add_nonsq_matrix_input(new_model_title, 'W',...
      'Edit the N X A sojourn-times matrix ',action_vector,state_vector,...
      [number_of_states number_of_actions],init_W);
   
   if isempty(W) 
      Next_process = 'select_mode';
      valid_input = 1;return;
      end
      P2=P;
      P=[];
      for a=1:number_of_actions
         if a <= original_noa
            init_P2 = P2((a-1)*original_nos+1:a*original_nos,:);
         else
            init_P2 = zeros(original_nos,original_nos)
         end
         

   init_P = zeros(number_of_states,number_of_states);
   init_P(1:min(number_of_states,original_nos),1:min(number_of_states,original_nos))...
      =init_P2(1:min(number_of_states,original_nos),1:min(number_of_states,original_nos));

           PP = add_matrix_input(new_model_title, 'P',...
         ['Edit the transition matrix for action ' num2str(a)],...
         state_vector, number_of_states,init_P);
           if isempty(PP) 
      Next_process = 'select_mode';
      valid_input = 1;return;
   end
P=[P;PP];
end

else
   valid_input = 1;
end



if valid_input == 1
      save new_model_parameters.mat new_model_title state_vector ... 
         action_vector C W P;
end
   end %rownum
   
   
end %switch model_class
   

