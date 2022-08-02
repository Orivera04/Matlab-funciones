function dist_called = distribution_input(rownum, std_state)

% INPUT PLATFORM FOR THE PARAMETERS OF THE STANDARD DISTRIBUTION INPUT

global Scale Primary_state Next_process Last_process Current_process...
   init_distributions_parm
global dist_called
%reset dist parameters
for k=1:7
   Primary_state(k).distribution_parm = init_distributions_parm{k};
   end;
% If this is not the correct procedure to be executing, return to caller
if strcmp(lower(Next_process), 'distribution_input') ~= 1
  return
else
  Current_process = 'distribution_input';
  Last_process = 'scalar_input' ;
  Next_process = 'distribution_parameter_input';
  end


dist_called=0;
% retrieve the labels of the currently seleted Primary and Standard model ;
model = Primary_state(rownum).model ;
primary_model = sprintf('Standard %s', model) ; 
model = Primary_state(rownum).std_model_array{std_state} ;
std_model = sprintf('%s Model', model) ;

switch model
   
case 'Inventory System'
   dist_num = [1 4 7 8];
   
case 'Telecommunication'
   dist_num = [1 4 7 8];

case 'G/M/1'
   dist_num = [3 2 4 8];
   
case 'Optimal Replacement'
   dist_num = [2 8];

end %switch model;


% retrieve the cell array of prob distributions corresponding to the Primary
% model selected
distribution_options = Primary_state(rownum).distribution_menu(std_state); 

% retrieve the dimension of the Std menu
m = Primary_state(rownum).distribution_num{std_state}{1};
% Display the parent figure
dinputfig = figure('Name', primary_model, ...
                  'NumberTitle','off', ...
                  'Units','normalized', ...
                  'Color',[0.76 0.76 0.76], ...
                  'Position',[.3 .5-.1*(m/2) .4 .1+.07*(max(m,5))], ...
                  'Menubar','none',...
                  'Tag','dinputfig');

% add exit, return to main, previous screen, and title
exit = exit_menu(dinputfig) ;
exit = return_to_main(dinputfig) ;
exit = previous_screen(dinputfig) ;
help_msg_id = [20 21 22 23 24 25 26 27 28
   30 31 32 33 34 35 36 37 38
   40 41 42 43 44 45 46 47 48
   50 51 52 53 54 55 56 57 58
   60 61 62 63 64 65 66 67 68
   70 71 72 73 74 75 76 77 78
   80 81 82 83 84 85 86 87 88];
exit = help_msg(dinputfig,help_msg_id(rownum,std_state));

uicontrol('Parent',dinputfig, ...
          'Units','normalized', ...
        	 'Position',[.1 .85 .8 .10], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize',Scale*20, ...
          'String', std_model) ;
  
  % Display parameter labels
uicontrol('Parent',dinputfig, ...
            'Units','normalized', ...
            'BackgroundColor', [0.76 0.76 0.76], ...
        	   'FontSize',Scale*15, ...
            'Fontname','time roman', ...
            'Position',[.1 .75 .8 .1], ...
          	'String', Primary_state(rownum).distribution_label{std_state}{1}, ...
	         'Style','text', ...
  	         'Tag','MDesc1');
           for k=1:m
               uicontrol('Parent',dinputfig, ...
            'Units','normalized', ...
            'Fontname','time roman', ...
            'Fontsize',Scale*12, ...
            'String', distribution_options{1}{k}, ...
            'Callback',[sprintf('set_dist_called(%i);',dist_num(k)),...
             'uiresume(gcbf);'], ...
            'Position',[.1 .05+(.7/m)*(m-k) .8 .7/(max(m,3))]) ;
      end
      uiwait(dinputfig)
      % Execute the following code only if the figure still exists
if ishandle(dinputfig)
  close(dinputfig)
end




