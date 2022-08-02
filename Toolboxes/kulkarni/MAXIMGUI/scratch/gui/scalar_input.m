function valid_input = scalar_input(rownum, std_state)

% INPUT PLATFORM FOR THE PARAMETERS OF all STANDARD MODELS

global Scale Primary_state Next_process Last_process Current_process
% If this is not the correct procedure to be executing, return to caller
if strcmp(lower(Next_process), 'scalar_input') ~= 1
   return
else
   Current_process = 'scalar_input';
   Last_process = 'select_standard_model' ;
   %Determine if distributional information should be collected next
   dist = 1;  %distributional input is  needed.
   Next_process = 'distribution_input';
   if isempty(Primary_state(rownum).distribution_label)
      dist = 0; %no distributional input needed
   else
      if isempty(Primary_state(rownum).distribution_label{std_state})
         dist = 0; %no distributional input needed
      end;
   end;
   
   
if dist == 0  %no distributional input needed
   % Determine whether vectors should be collected next
   if isempty(Primary_state(rownum).vector_label)
      Next_process = 'workbench';
   elseif isempty(Primary_state(rownum).vector_label{std_state})
      Next_process = 'workbench' ;
   else
      Next_process = 'vector_input' ;
   end;
end;
end;


   

% retrieve the labels of the currently selected Primary and Standard model ;
model = Primary_state(rownum).model ;
primary_model = sprintf('Standard %s', model) ; 
model = Primary_state(rownum).std_model_array{std_state} ;
std_model = sprintf('%s Model', model) ;

% retrieve the number of scalar inputs for the selected model
m = size(Primary_state(rownum).scalar_parm{std_state}, 2) ;

% Display the parent figure
sinputfig = figure('Name', primary_model, ...
                  'NumberTitle','off', ...
                  'Units','normalized', ...
                  'Color',[0.76 0.76 0.76], ...
                  'Position',[.25 max(.05,.5-.1*m) .5 min(.1*m+.3,.8)], ...
                  'Menubar','none',...
                  'Tag','sinputfig');

% add exit, return to main, previous screen, and title
exit = exit_menu(sinputfig) ;
exit = return_to_main(sinputfig) ;
exit = previous_screen(sinputfig) ;
% initialize help_message_ids
help_msg_id = [20 21 22 23 24 25 26 27 28
   30 31 32 33 34 35 36 37 38
   40 41 42 43 44 45 46 47 48
   50 51 52 53 54 55 56 57 58
   60 61 62 63 64 65 66 67 68
   70 71 72 73 74 75 76 77 78
   80 81 82 83 84 85 86 87 88];
exit = help_msg(sinputfig,help_msg_id(rownum,std_state));


uicontrol('Parent',sinputfig, ...
          'Units','normalized', ...
        	 'Position',[.25 .75 .5 .23], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize',Scale*20, ...
          'String', std_model) ;

% Display message for models with no scalar input required
if m == 0
  uicontrol('Parent',sinputfig, ...
	         'Units','normalized', ...
            'BackgroundColor', [0.76 0.76 0.76], ...
            'HorizontalAlignment','center',...
       	   'FontSize',Scale*20, ...
            'Fontname','time roman', ...
            'Position',[.25 .40 .5 .25], ...
      	   'String', 'No scalar input required', ...
	         'Style','text', ...
	         'Tag','StaticText1');
else
  for k = 1:m
    % Display parameter labels
    uicontrol('Parent',sinputfig, ...
	           'Units','normalized', ...
              'BackgroundColor', [0.76 0.76 0.76], ...
              'HorizontalAlignment','right',...
       	     'FontSize',Scale*14, ...
              'Fontname','time roman', ...
              'Position',[.1 .255+(m-k)*(10-m)*.02 .40 (10-m)*.02], ...
          	  'String', Primary_state(rownum).scalar_label{std_state}(k), ...
	           'Style','text', ...
  	           'Tag','StaticText1');

     % Retrieve current value of each scalar field
     current_value(k) = Primary_state(rownum).scalar_parm{std_state}(k) ;

     % Display entry fields for scalar parameters 
     % Note - values must be put into the temporary current_value vector
     %        and updated into the appropriate Primary_state slots later
     e(k) = uicontrol('Parent',sinputfig, ...
  	                   'Units','normalized', ...
                   	 'BackgroundColor',[1 1 1], ...
                      'Position',[.55 .255+(m-k)*(10-m)*.02 .25 (10-m)*.02], ...
                      'HorizontalAlignment','left',...
                      'Fontsize',Scale*12, ...
                      'String', current_value(k), ...
	                   'Style','edit') ;
  end
end 

% OK button
uicontrol('Parent',sinputfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', 'uiresume(gcbf)',...
          'FontName','time roman', ...
	       'Fontsize',Scale*18, ...
	       'Position',[.45 .05 .1 (10-m)*.015], ...
          'String','OK') ;

uiwait(sinputfig)

% Execute the following code only if the figure still exists
if ishandle(sinputfig)
  % Update the Primary_state structure with the new scalars
  for v = 1:m
    Primary_state(rownum).scalar_parm{std_state}(v) = get(e(v), 'String') ;
  end ;

  % validate input
  valid_input = validate_scalar_parameters(rownum, std_state, m) ;

  if (valid_input == 0) 
    Next_process = 'scalar_input' ;
  end

  close(sinputfig)

% If Previous Screen, return valid_input such that we can exit the loop
else
  valid_input = 1 ;
end
