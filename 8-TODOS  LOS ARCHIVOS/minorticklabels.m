plt(1:100)
% Medium sized ticks every five:
axes('ytick',[],...
    'xtick',0:5:100,...
    'xlim',[0 100],...
    'xticklabel','',...
    'ticklength',[.007 0],...
    'color','none')

% Tiny tick marks every one:
axes('ytick',[],...
    'xtick',1:100,...
    'xlim',[0 100],...
    'xticklabel','',...
    'ticklength',[.005 0],...
    'color','none')
