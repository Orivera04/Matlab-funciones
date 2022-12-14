function matrix_input = add_matrix_input(title_name,varname,varlabel,state_vector,matrix_size,init_matrix)

% INPUT PLATFORM FOR THE PARAMETERS OF THE STANDARD MATRIX INPUT
global Scale AMValue AMHLabel_handle AMVLabel_handle AMValue_handle AMHLabel AMVLabel cancel_win
global stp1 stp2
stp1 = 0; stp2 = 0;
%initialize variables
valid_input = 0;
% max size of a matrix on screen at one time = 10X10
num_disp = min(matrix_size, 10) ;
if isempty(state_vector)
   AMHLabel = [1:matrix_size];
   AMVLabel = [1:matrix_size];
else
   AMHLabel = state_vector;
   AMVLabel = state_vector;
end

while(valid_input == 0)
   AMValue = init_matrix;

   % Display the main figure
   aminputfig = figure('Name', title_name, ...
                  'NumberTitle','off', ...
                  'Units','normalized', ...
                  'Color',[0.76 0.76 0.76], ...
                  'Position',[.5-.04*10 .07 .08*10 .08*10], ...
                  'Menubar','none',...
                  'Tag','aminputfig');

uicontrol('Parent',aminputfig, ...
          'Units','normalized', ...
        	 'Position',[.1 .85 .8 .15], ...
          'Style','text', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Fontname','time roman', ...
          'Fontsize',Scale*20, ...
          'HorizontalAlignment','left',...
          'String', sprintf('%s :', varlabel)) ;
 
     for k = 1:num_disp
     AMVLabel_handle(k) = uicontrol('Parent',aminputfig, ...
	                                'Units','normalized', ...
                                   'BackgroundColor',[0.76 0.76 0.76], ...
                                   'Position',[.05 .75-.06*k .08 .06], ...
                                   'HorizontalAlignment','center',...
                                   'Fontsize',Scale*12, ...
                                   'String', sprintf('%d', AMVLabel(k)), ...
	                                'Style','text', ...
                                   'Tag', sprintf('MatrixLabel%d', k), ...
                                   'UserData', [k])' ;
     AMHLabel_handle(k) = uicontrol('Parent',aminputfig, ...
	                                'Units','normalized', ...
                                   'BackgroundColor',[0.76 0.76 0.76], ...
                                   'Position',[.05 + .08*k .75 .08 .06], ...
                                   'HorizontalAlignment','center',...
                                   'Fontsize',Scale*12, ...
                                   'String', sprintf('%d', AMHLabel(k)), ...
	                                'Style','text', ...
                                   'Tag', sprintf('MatrixLabel%d', k), ...
                                   'UserData', [k])' ;


     for s=1:num_disp
    % Display labels for each matrix element
        % Display entry fields for parameters 
    AMValue_handle(k,s) = uicontrol('Parent',aminputfig, ...
	                                'Units','normalized', ...
                                   'BackgroundColor',[1 1 1], ...
                                   'Position',[.05+.08*s .75- .06*k .08 .06], ...
                                   'HorizontalAlignment','center',...
                                   'Fontsize',Scale*12, ...
                                   'String', AMValue(k,s), ...
	                                'Style','edit', ...
                                   'Tag', sprintf('MatrixValue%d_%d', k, s), ...
                                   'UserData', [k s]) ;
    end %for s
end  % for k


% Sliders
  if matrix_size > num_disp

    if matrix_size - num_disp == 1
      eachstep = .99; 
    else 
      eachstep = 1 / (matrix_size - num_disp); 
    end

    uicontrol('Parent',aminputfig, ...
	           'Units','normalized', ...
	           'Position',[.13 .82 .08*num_disp .05], ...
	           'Style','slider', ...
              'SliderStep', [eachstep 1], ...
              'Value', 0, ...
              'Callback', [sprintf('update_add_matrix_values(%d);',num_disp), ...
                           sprintf('amhscroll(%d);',num_disp)], ...
              'Tag','AMHSlider1') ;
                     
    uicontrol('Parent',aminputfig, ...
	           'Units','normalized', ...
	           'Position',[.025 .15 .03 .06*num_disp], ...
	           'Style','slider', ...
              'SliderStep', [eachstep 1], ...
              'Value', 1, ...
              'Callback', [sprintf('update_add_matrix_values(%d);',num_disp), ...
                           sprintf('amvscroll(%d);',num_disp)], ...
              'Tag', 'MVSlider1') ;

                     
                     
  end  % if
% OK button
uicontrol('Parent',aminputfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', 'uiresume(gcbf)',...
          'FontName','time roman', ...
	       'Fontsize',Scale*18, ...
	       'Position',[.45 .05 .08 .06], ...
          'String','OK') ;
       %CANCEL button
uicontrol('Parent',aminputfig, ...
          'Units','normalized', ...
          'BackgroundColor', [0.76 0.76 0.76], ...
          'Callback', ['set_cancel;uiresume(gcbf);'],...
          'FontName','time roman', ...
          'Fontsize',Scale*14, ...
          'Position',[.55 .05 .15 .06], ...
          'String','Cancel', ...
          'Tag', 'Cancel') ;

       uiwait(aminputfig)
       
if (cancel_win == 1)
   matrix_input = [] ;
   valid_input = 1; %to get out of the loop.
else
   update_add_matrix_values(num_disp);
   matrix_input = AMValue;
      valid_input = validate_add_matrix_parameters(varname,matrix_input);
end
if valid_input == 0
   init_matrix = matrix_input;
   close(aminputfig)
end
end; %end while

close(aminputfig)





