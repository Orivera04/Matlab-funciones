function prob_output(title_bar, title, mean_var, num_cdf, num_pmf)

global Scale Num_cdf Cdf_handles Num_pmf Pmf_handles

Num_cdf = num_cdf ;
Num_pmf = num_pmf ;

% Output numerical results of a Probability Model

probfig = figure('Name', title_bar, ...
                 'Color',[0.8 0.8 0.8], ...
                 'Units', 'normalized', ...
	              'Position', [.03 .1 .5 .75], ...
                 'Menubar', 'none', ...
                 'NumberTitle', 'off', ...
	              'Tag','probfig');

% Menu options for this figure
exit = uimenu(probfig, ...
              'Label', 'Close Figure',...
              'Tag','CloseFig', ...
              'Callback','close') ;
save = uimenu(probfig, ...
              'Label', 'Save Results', ...
              'Callback', sprintf('printto(''prob'', ''file'') ;'), ...
              'Tag', 'SaveFig') ;
%prnt = uimenu(probfig, ...
 %             'Label', 'Print Results', ...
  %            'Callback', sprintf('printto(''prob'', ''printer'') ;'), ...
   %           'Tag', 'PrintFig') ;

% Text labels
uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
          'Position',[.25 .92 .5 .05], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', Scale*14, ...
          'Style','text', ...
          'String', title, ...
          'Tag','Title');
uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
	       'Position',[.25 .84 .20 .05], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', Scale*12, ...
	       'Style','text', ...
          'String', 'Mean', ...
	       'Tag','MeanLabel');
uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
	       'Position',[.55 .84 .20 .05], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', Scale*12, ...
	       'Style','text', ...
          'String', 'Variance', ...
	       'Tag','VarLabel');
if ~isempty(Num_cdf) 
       uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
	       'Position',[.15 .70 .25 .05], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', Scale*10, ...
	       'Style','text', ...
          'String', 'Numerical CDF', ...
	       'Tag','CDFLabel');
       uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
	       'Position',[.6 .70 .25 .05], ...
          'BackgroundColor',[0.8 0.8 0.8], ...
          'Fontsize', Scale*10, ...
	       'Style','text', ...
          'String', 'Numerical PMF/PDF', ...
	       'Tag','PMFLabel');
end;
% Results
% Mean
uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
	       'BackgroundColor',[1 1 1], ...
	       'Position',[.25 .80 .20 .04], ...
	       'Style','edit', ...
          'String', sprintf('%12.5f', mean_var(1)), ...
	       'Tag','Mean');
% Variance
uicontrol('Parent',probfig, ...
	       'Units','normalized', ...
	       'BackgroundColor',[1 1 1], ...
	       'Position',[.55 .80 .20 .04], ...
	       'Style','edit', ...
          'String', sprintf('%12.5f', mean_var(2)), ...
	       'Tag','Variance');

% CDF
% Determine number of CDF and PMF boxes required
if ~isempty(num_cdf)
cdf_size = size(num_cdf, 1) ;
vdim = min(cdf_size, 12) ;

for k = 1:vdim
  cdf1(k) = uicontrol('Parent',probfig, ...
	                   'Units','normalized', ...
	                   'BackgroundColor',[1 1 1], ...
	                   'Position',[.15 .62-((k-1)*.05) .11 .05], ...
	                   'Style','edit', ...
                      'String', sprintf('%i', num_cdf(k, 1)), ...
	                   'Tag',sprintf('CDF1_%i', k));

  cdf2(k) = uicontrol('Parent',probfig, ...
	                   'Units','normalized', ...
	                   'BackgroundColor',[1 1 1], ...
	                   'Position',[.28 .62-((k-1)*.05) .11 .05], ...
    	                'Style','edit', ...
                      'String', sprintf('%7.5f', num_cdf(k, 2)), ...
	                   'Tag',sprintf('CDF2_%i', k));
end
Cdf_handles = [cdf1; cdf2]' ;

% PMF/PDF
for k = 1:vdim
  pmf1(k) = uicontrol('Parent',probfig, ...
	                   'Units','normalized', ...
	                   'BackgroundColor',[1 1 1], ...
	                   'Position',[.61 .62-((k-1)*.05) .11 .05], ...
	                   'Style','edit', ...
                      'String', sprintf('%i', num_pmf(k, 1)), ...
	                   'Tag',sprintf('PMF1_%i', k));

  pmf2(k) = uicontrol('Parent',probfig, ...
	                   'Units','normalized', ...
	                   'BackgroundColor',[1 1 1], ...
	                   'Position',[.74 .62-((k-1)*.05) .11 .05], ...
    	                'Style','edit', ...
                      'String', sprintf('%7.5f', num_pmf(k, 2)), ...
	                   'Tag',sprintf('PMF2_%i', k));
end
Pmf_handles = [pmf1; pmf2]' ;
 
if cdf_size > vdim

  if cdf_size - vdim == 1
    eachstep = .99 ;
  else
    eachstep = 1 / (cdf_size - vdim) ;
  end

  % cdf slider
  uicontrol('Parent',probfig, ...
	         'Units','normalized', ...
	         'Position',[.06 .05 .04 .63], ...
	         'Style','slider', ...
            'SliderStep', [eachstep 1], ...
            'Value', 1, ...
            'Callback', sprintf('scroll_cdf(%d)', vdim), ...
	         'Tag','CDF_Slider') ;

  % pmf slider
  uicontrol('Parent',probfig, ...
  	         'Units','normalized', ...
	         'Position',[.9 .05 .04 .63], ...
	         'Style','slider', ...
            'SliderStep', [eachstep 1], ...
            'Value', 1, ...
            'Callback', sprintf('scroll_pmf(%d)', vdim), ...
	         'Tag','PMF_Slider') ;
      end
      end