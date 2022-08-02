function valid_input = vector_input(rownum, std_state)

% INPUT PLATFORM FOR THE VECTOR PARAMETERS 

global Scale Primary_state VLabel_handle VValue_handle VValue VLabel ...
   Next_process Last_process vector_size vbase Current_process 
%Note: VValue, VLabel_handle, and VValue_handle are used globally only in a local sense - 
%      that is, the values are declared global in order to facilitate scrolling;
%      however, the final values are added to the Primary_state as needed and otherwise discarded.

% If this is not the correct procedure to be executing, return to caller

if strcmp(lower(Next_process), 'vector_input') ~= 1
  return
else
   Current_process = 'vector_input';
   if isempty(Primary_state(rownum).distribution_parm)
      Last_process = 'scalar_input';
   elseif isempty(Primary_state(rownum).distribution_parm{std_state})
      Last_process = 'scalar_input';
   elseif Primary_state(rownum).distribution_parm{std_state}{8}{1} ~= -1
      Last_process = 'distribution_input';
   else
      Last_process = 'scalar_input' ;
   end
   
  % Determine whether matrix should be collected next
  if (isempty(Primary_state(rownum).matrix_label))
    Next_process = 'workbench' ;
  elseif isempty(Primary_state(rownum).matrix_label{std_state})
    Next_process = 'workbench' ;
  else
    Next_process = 'matrix_input' ;
  end
end

% retrieve the labels of the currently selected Primary and Standard model ;
model = Primary_state(rownum).model ;
primary_model = sprintf('Standard %s', model) ; 
model = Primary_state(rownum).std_model_array{std_state} ;
std_model = sprintf('%s Model', model) ;

% retrieve the number of vector inputs for the selected model
m = size(Primary_state(rownum).vector_label{std_state}, 2) ;

offset = (3 - m) * 0.1 ;





 % Display the parent figure
vinputfig = figure('Name', primary_model, ...
                  'NumberTitle','off', ...
                  'Units','normalized', ...
                  'Color',[0.76 0.76 0.76], ...
                  'Position',[.2 max(.07,.5-.15*m) .6 .15*m+.3], ...
                  'Menubar','none',...
                  'Tag','vinputfig');

% add exit, return to main, previous screen, and title
exit = exit_menu(vinputfig) ;
exit = return_to_main(vinputfig) ;
exit = previous_screen(vinputfig) ;
% initialize help_message_ids
help_msg_id = [20 21 22 23 24 25 26 27 28
   30 31 32 33 34 35 36 37 38
   40 41 42 43 44 45 46 47 48
   50 51 52 53 54 55 56 57 58
   60 61 62 63 64 65 66 67 68
   70 71 72 73 74 75 76 77 78
   80 81 82 83 84 85 86 87 88];
exit = help_msg(vinputfig,help_msg_id(rownum,std_state));


uicontrol('Parent',vinputfig, ...
          'Units','normalized', ...
        	 'Position',[.1 .75 .8 .2], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize',Scale*20, ...
          'String', std_model) ;

% initialize vector handles with zeros such that vector handles of differing
% dimensions can be stored in one matrix
VLabel_handle = zeros(m, min(max(vector_size), 9)) ;
VValue_handle = zeros(m, min(max(vector_size), 9)) ;

for k = 1:m
  % Display parameter labels
  uicontrol('Parent',vinputfig, ...
            'Units','normalized', ...
            'BackgroundColor', [0.76 0.76 0.76], ...
            'HorizontalAlignment','left',...
       	   'FontSize',Scale*15, ...
            'Fontname','time roman', ...
            'Position',[.05 .75-(k-1)*(.225+(3-m)*.05) .5 .07], ...
          	'String', Primary_state(rownum).vector_label{std_state}(k), ...
	         'Style','text', ...
  	         'Tag',sprintf('VDesc%d', k));

  % max number of boxes on screen at one time = 18
  num_disp(k) = min(vector_size(k), 9) ;

  % retrieve next vertical position
  current_pos = get(findobj('Tag', sprintf('VDesc%d', k)), 'Position') ;
  v_pos = current_pos(2) ;

  for s = 1:num_disp(k)
    % Display labels for each vector element
    VLabel_handle(k,s) = uicontrol('Parent',vinputfig, ...
	                                'Units','normalized', ...
                                   'BackgroundColor',[0.76 0.76 0.76], ...
                                   'Position',[.1*s v_pos-.05-(offset/4) .1 .05+(offset/4)], ...
                                   'HorizontalAlignment','center',...
                                   'Fontsize',Scale*12, ...
                                   'String', VLabel(s), ...
	                                'Style','text', ...
                                   'Tag', sprintf('VectorLabel%d_%d', k, s), ...
                                   'UserData', [k s])' ;

    % Display entry fields for parameters 
    VValue_handle(k,s) = uicontrol('Parent',vinputfig, ...
	                                'Units','normalized', ...
                                   'BackgroundColor',[1 1 1], ...
                                   'Position',[.1*s v_pos-2*(.05+(offset/4)) .1 .05+(offset/4)], ...
                                   'HorizontalAlignment','center',...
                                   'Fontsize',Scale*12, ...
                                   'String', VValue(k,s), ...
	                                'Style','edit', ...
                                   'Tag', sprintf('VectorValue%d_%d', k, s), ...
                                   'UserData', [k s]) ;
  end

  % Sliders
  if vector_size(k) > num_disp(k)

    if vector_size(k) - num_disp(k) == 1
      eachstep = .99 ;
    else 
      eachstep = 1 / (vector_size(k) - num_disp(k)) ;
    end

    uicontrol('Parent',vinputfig, ...
	           'Units','normalized', ...
	           'Position',[.1 v_pos-2*(.05+(offset/4))-((4-m)*.025) .9 (4-m)*.025], ...
	           'Style','slider', ...
              'SliderStep', [eachstep 1], ...
              'Value', 0, ...
              'Callback', [sprintf('update_vector_values(%d, %d);', k, num_disp(k)), ...
                           sprintf('hscroll(%d, %d, %d);', k, num_disp(k), vector_size(k))], ...
	           'Tag', sprintf('HSlider%d', k)) ;
  end  % if
end  % for k=1:m

% OK button
uicontrol('Parent',vinputfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', 'uiresume(gcbf)',...
          'FontName','time roman', ...
	       'Fontsize',Scale*18, ...
	       'Position',[.45 .05 .1 (10-m)*.015], ...
          'String','OK') ;
uiwait(vinputfig)

% Execute the following code only if the figure still exists
if ishandle(vinputfig)

  % Update all vectors once OK is selected
  update_vector_values(0, num_disp) ;

% Update the Primary_state structure with the new vectors
      Primary_state(rownum).vector_matrix = VValue;
 


% validate input
valid_input = validate_vector_parameters(rownum, std_state,vector_size) ;
if (valid_input == 0) 
    Next_process = 'vector_input' ;
  end
  close(vinputfig)

% If Previous Screen, return valid_input such that we can exit the loop
else
   
  valid_input = 1 ;
end
