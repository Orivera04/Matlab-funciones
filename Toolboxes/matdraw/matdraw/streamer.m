function handle = streamer(fig,TitleString)
%  STREAMER  Titles for an entire figure.
% 	     STREAMER('text') adds text at the top of the current figure,
% 	     going across subplots.
%        STREAMER(fig,'text') adds it to the specified figure.
% 
% 	     See also XLABEL, YLABEL, ZLABEL, TEXT, TITLE.
%
%	Keith Rogers 11/30/93

% Copyright (c) by Keith Rogers 1995

% 
% Mods:
%	11/94 adapted to 4.2
%   06/95 clean up, added alternate figure option.

if(nargin<2)
	TitleString = fig;
	fig = gcf;
end
ax = gca;
sibs = get(fig, 'Children');
for i = 1:max(size(sibs))
	if(strcmp(get(sibs(i),'Type'),'axes'))
		if(strcmp(get(sibs(i),'Tag'),'Streamer'))
				StreamerHand = sibs(i);
		end
	end
end
if (exist('StreamerHand')~=2)
	figure(fig);
	StreamerHand = axes('Units','normalized',...
						'Position',[.1 .9 .8 .05],...
						'Box','off',...
						'Visible','off',...
						'Tag','Streamer');
	handle = get(gca,'Title');
	set(handle,'Visible','On');
else
	handle = get(gca,'Title');
	axes(StreamerHand);
end
title(TitleString);
axes(ax);

