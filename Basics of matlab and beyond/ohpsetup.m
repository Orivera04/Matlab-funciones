% OHPSETUP Set up figure for overhead transparencies.

function ohpsetup(PP)
  
if nargin==0
  PP = input(['DSTO PowerPoint colours ' ...
	'(yellow on a blue background) y/[n] ? '],...
      's');
end
if isempty(PP),PP = 'n';end
if strcmp(lower(PP),'y')
  set(0,'defaultfigurecolor',[0 23/255 46/255])
  set(0,'DefaultAxesColor','none')
  set(0,'defaultaxescolororder', ...
      [[253 255 221]/255 ; ...
	.75   1   .75 ; ...
	1    0    1 ; ...
	1   .7    .2 ; ...
	1   1     0 ; ...
	1    .25    .25 ; ...
	0 1 1])
  set(0,'defaultaxesxcolor',[253 255 221]/255)
  set(0,'defaultaxesycolor',[253 255 221]/255)
  set(0,'defaultaxeszcolor',[253 255 221]/255)
  set(0,'defaultsurfaceedgecolor',[0 0 0]/255)
  set(0,'defaultlinecolor',[253 255 221]/255)
  set(0,'defaulttextcolor',[253 255 221]/255)
end
set(0,'defaultlinelinewidth',2)
set(0,'defaultlinemarkersize',12)
set(0,'defaultpatchlinewidth',1)
set(0,'defaultsurfacelinewidth',1)
set(0,'defaultaxeslinewidth',1)
set(0,'defaultaxesfontname','Palatino')
set(0,'defaultaxesfontsize',18)
set(0,'defaulttextfontname','Palatino')
set(0,'defaulttextfontsize',18)
figunits = get(0,'defaultfigureunits');

% Set the figure to about the size of a transparency, then resore the units:
set(0,'defaultfigureunits','pixels','defaultfigurepos',[14 29 924 618],'defaultfigureunits',figunits)



