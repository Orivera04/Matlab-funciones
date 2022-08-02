function select_standard_model(rownum) ;

% function displays menu from which to choose a Standard Model

global Primary_state Scale Next_process Last_process Current_process

% If this is not the correct procedure to be executing, return to caller
if strcmp(lower(Next_process), 'select_standard_model') ~= 1
  return
else
   Current_process = 'select_standard_model';
  Last_process = 'select_mode' ;
  Next_process = 'scalar_input' ;
end

% retrieve the label of the currently selected Primary model ;
model = Primary_state(rownum).model ;
module_name = sprintf('Standard %s', model) ; 

% retrieve the cell array of Std models corresponding to the Primary
% model selected
std_model_array = Primary_state(rownum).std_model_array ;

% retrieve the dimension of the Std menu
m = Primary_state(rownum).std_menu_num ;
 
stdfig = figure('Name', module_name, ...
                'NumberTitle','off', ...
                'Units','normalized', ...
                'Color',[0.76 0.76 0.76], ...
                'Position',[.3 .5-.1*(m/2) .4 .1+.07*(max(m,5))], ...
                'Menubar','none',...
                'Tag','StdFig');

% add exit, return to main, previous screen, and title
exit = exit_menu(stdfig) ;
exit = return_to_main(stdfig) ;
exit = previous_screen(stdfig) ;
% initialize help_message_ids
help_msg_id = [9 10 11 12 13 14 15];
exit = help_msg(stdfig,help_msg_id(rownum));


uicontrol('Parent',stdfig, ...
          'Units','normalized', ...
        	 'Position',[.25 .75 .5 .25], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize',Scale*20, ...
          'String', module_name) ;

for k=1:m
  uicontrol('Parent',stdfig, ...
            'Units','normalized', ...
            'Fontname','time roman', ...
            'Fontsize',Scale*12, ...
            'String', std_model_array{k}, ...
            'Callback',[sprintf('set_std_model_state(%i, %i );', rownum, k), ...
                        'uiresume(gcbf)'], ...
            'Position',[.1 .05+(.7/m)*(m-k) .8 .7/(max(m,3))]) ;
end

% wait for user to select a mode before closing and returning to caller
uiwait(stdfig)

% Execute this code only if the figure still exists
if ishandle(stdfig)
  close(stdfig)
end
