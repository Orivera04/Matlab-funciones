function control_output(control_problem, opt_policy, opt_value)

global Scale  control_state control_policy state_vector
% Output numerical results of a Design Model
std_state = get_std_model_state(7);

controlfig = figure('Name', 'Optimal Control', ...
                 'Color',[0.8 0.8 0.8], ...
                 'Units', 'normalized', ...
	              'Position', [.45 .05 .5 .9], ...
                 'Menubar', 'none', ...
                 'NumberTitle', 'off', ...
	              'Tag','controlfig');

% Menu options for this figure
exit = uimenu(controlfig, ...
              'Label', 'Close Figure',...
              'Tag','CloseFig', ...
              'Callback','close') ;
save = uimenu(controlfig, ...
              'Label', 'Save Results', ...
              'Callback', sprintf('printto(''control'', ''file'') ;'), ...
              'Tag', 'SaveFig') ;
if std_state == 0           
save_model = uimenu(controlfig, ...
              'Label', 'Save Model', ...
              'Callback', sprintf('save_new_model(7);'), ...
              'Tag', 'PrintFig') ;
end

% Text labels
uicontrol('Parent',controlfig, ...
	       'Units','normalized', ...
          'Position',[.1 .9 .8 .08], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', 14, ...
          'Style','text', ...
          'String', control_problem, ...
          'Tag','Title');
uicontrol('Parent',controlfig, ...
	       'Units','normalized', ...
	       'Position',[.25 .8 .5 .08], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', 14, ...
	       'Style','text', ...
          'String', 'Optimal Cost Rate', ...
          'Tag','OptValLabel');
uicontrol('Parent',controlfig, ...
	       'Units','normalized', ...
	       'Position',[.25 .6 .2 .08], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', 12, ...
	       'Style','text', ...
          'String', 'State Label', ...
          'Tag','StateLabel');
uicontrol('Parent',controlfig, ...
	       'Units','normalized', ...
	       'Position',[.55 .6 .2 .08], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', 12, ...
	       'Style','text', ...
          'String', 'Optimal Action', ...
          'Tag','ActionLabel');

% Results
policy_size = size(opt_policy, 2); 
vdim = min(policy_size, 10) ;

for k = 1:vdim
  control_state(k) = uicontrol('Parent',controlfig, ...
	                   'Units','normalized', ...
	                   'BackgroundColor',[1 1 1], ...
	                   'Position',[.30 .50-((k-1)*.05) .10 .05], ...
	                   'Style','edit', ...
                      'String', sprintf('%i', state_vector(k)), ...
	                   'Tag',sprintf('state_%i', k));

  control_policy(k) = uicontrol('Parent',controlfig, ...
	                   'Units','normalized', ...
	                   'BackgroundColor',[1 1 1], ...
	                   'Position',[.60 .50-((k-1)*.05) .10 .05], ...
    	                'Style','edit', ...
                      'String', sprintf('%i', opt_policy(k)), ...
	                   'Tag',sprintf('policy_%i', k));
end

if policy_size > vdim

  if policy_size - vdim == 1
    eachstep = .99 ;
  else
    eachstep = 1 / (policy_size - vdim) ;
  end

  % state/policy slider
  uicontrol('Parent',controlfig, ...
	         'Units','normalized', ...
	         'Position',[.48 .05 .04 .50], ...
	         'Style','slider', ...
            'SliderStep', [eachstep 1], ...
            'Value', 1, ...
            'Callback', sprintf('scroll_control(%d)', vdim), ...
	         'Tag','Policy_Slider') ;

      end
      
   % Optimal Value
uicontrol('Parent',controlfig, ...
	       'Units','normalized', ...
	       'BackgroundColor',[1 1 1], ...
	       'Position',[.4 .75 .2 .05], ...
	       'Style','edit', ...
          'String', sprintf('%12.5f', opt_value), ...
	       'Tag','OptVal');

