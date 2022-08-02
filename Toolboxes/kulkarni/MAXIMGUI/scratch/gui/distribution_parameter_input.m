function valid_input = distribution_parameter_input(k,rownum,std_state);
global Next_process Last_process Current_process Primary_state Scale
global valid_input dist_called vbase
distribution_items = {'Binomial' 'Erlang' 'Exponential' 'Geometric' ...
                    'Negative Binomial' 'Normal' 'Poisson' 'Discrete {0 ... N}'} ;
distribution_parm_labels =  { {'n' 'p'} {'k' 'lambda'} {'lambda'} {'p'} ...
         {'r' 'p'} {'mu' 'sigma'} {'lambda'} {'N'}};
parm_init_values = { {0 0} {0 0} {0} {0} ...
      {0 0} {0 0} {0} {0}};
Last_process = 'distribution_input';
Current_process = 'distribution_parameter_input';
if isempty(Primary_state(rownum).vector_label)
      Next_process = 'workbench';
   elseif isempty(Primary_state(rownum).vector_label{std_state})
      Next_process = 'workbench' ;
   else
      Next_process = 'vector_input' ;
   end;

dist_called = k;
% retrieve the labels of the currently seleted Primary and Standard model ;
 
model = Primary_state(rownum).std_model_array{std_state} ;
std_model = sprintf('%s Model', model) ;
chosen_dist = distribution_items{k};
% retrieve the number of scalar inputs for the selected distribution
m = size(distribution_parm_labels{k}, 2); 

% Display the parent figure
ddinputfig = figure('Name', std_model, ...
                  'NumberTitle','off', ...
                  'Units','normalized', ...
                  'Color',[0.76 0.76 0.76], ...
                  'Position',[.25 max(.05,.5-.1*m) .5 min(.1*m+.3,.8)], ...
                  'Menubar','none',...
                  'Tag','ddinputfig');

% add exit, return to main, previous screen, and title
exit = exit_menu(ddinputfig) ;
exit = return_to_main(ddinputfig) ;
exit = previous_screen(ddinputfig) ;
help_msg_id = [20 21 22 23 24 25 26 27 28
   30 31 32 33 34 35 36 37 38
   40 41 42 43 44 45 46 47 48
   50 51 52 53 54 55 56 57 58
   60 61 62 63 64 65 66 67 68
   70 71 72 73 74 75 76 77 78
   80 81 82 83 84 85 86 87 88];
exit = help_msg(ddinputfig,help_msg_id(rownum,std_state));
uicontrol('Parent',ddinputfig, ...
          'Units','normalized', ...
        	 'Position',[.25 .75 .5 .23], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize',Scale*15, ...
          'String', sprintf('%s\n %s distribution', std_model, chosen_dist)) ;

% Display message for models with no scalar input required
  for kk = 1:m
    % Display parameter labels
    uicontrol('Parent',ddinputfig, ...
	           'Units','normalized', ...
              'BackgroundColor', [0.76 0.76 0.76], ...
              'HorizontalAlignment','right',...
       	     'FontSize',Scale*15, ...
              'Fontname','time roman', ...
              'Position',[.1 .255+(m-kk)*(10-m)*.02 .35 (10-m)*.02], ...
          	  'String', distribution_parm_labels{k}(kk), ...
	           'Style','text', ...
  	           'Tag','StaticText1');

     
     % Display entry fields for scalar parameters 
     e(kk) = uicontrol('Parent',ddinputfig, ...
  	                   'Units','normalized', ...
                   	 'BackgroundColor',[1 1 1], ...
                      'Position',[.5 .255+(m-kk)*(10-m)*.02 .25 (10-m)*.02], ...
                      'HorizontalAlignment','left',...
                      'Fontsize',Scale*12, ...
                      'String', Primary_state(rownum).distribution_parm{std_state}{k}(kk), ...
	                   'Style','edit') ;
  end

% OK button
uicontrol('Parent',ddinputfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', 'uiresume(gcbf)',...
          'FontName','time roman', ...
	       'Fontsize',Scale*18, ...
	       'Position',[.45 .05 .1 (10-m)*.015], ...
          'String','OK') ;

uiwait(ddinputfig)

% Execute the following code only if the figure still exists
if ishandle(ddinputfig)
  % Update the Primary_state structure with the new scalars
  for v = 1:m
    Primary_state(rownum).distribution_parm{std_state}{k}(v) = get(e(v), 'String'); 
  end ;

  % validate input
  valid_input = validate_distribution_parameter(rownum, std_state, k,m) ;
  if (valid_input == 1)
     switch model
     case 'Inventory System'
        if Primary_state(rownum).distribution_parm{std_state}{8}{1} == -1
           Next_process = 'workbench';
        end;
     case 'Telecommunication'
        if Primary_state(rownum).distribution_parm{std_state}{8}{1} == -1
           Next_process = 'workbench';
        end;
     case 'G/M/1'
        if Primary_state(rownum).distribution_parm{std_state}{8}{1} == -1
           Next_process = 'workbench';
        end;
     case 'Optimal Replacement'
        if Primary_state(rownum).distribution_parm{std_state}{8}{1} == -1
           Next_process = 'workbench';
        end;
     end %switch model;
  end;
  

        
               
  close(ddinputfig)

% If Previous Screen, return valid_input such that we can exit the loop
else
  valid_input = 1 ;
end
