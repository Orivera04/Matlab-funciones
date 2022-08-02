function pfig = palette(toolList,paletteName,callback,GlobalName)
%
% function pfig = palette(toolList,paletteName,callback,GlobalName)
% Creates a palette figure.
% toolList     is a string of single character symbols, each of
%              which will become a palette item.
% paletteName  is the name that the palette figure will be
%              given.
% callback     is the function where processing of user
%              actions involving the palette will take
%              place.  When the user selects a palette item,
%              a command of the form <callback>(switch)
%              is generated, where <callback> is the string
%              specified here and "switch" will contain the
%              character label of the item selected.
%
%	Keith Rogers 11/94

%Mods:
%
%  01/19/95:  Turn off 'Resize', and 'NumberTitle' properties
%  10/25/95:  Turned off menubar.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note:  The method of patches and text objects  %
% used here is awfully ugly, but it updates much %
% more quickly than if I had used uicontrols,    %
% and this is very noticeable on slower systems. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Copyright (c) 1995 by Keith Rogers 

	   
% Create the Palette figure

if(nargin == 4)
	numberOfTools = length(toolList);
	pfig = figure('Position',[50 350 30 30*numberOfTools],...
				  'Color',[1 1 1],...
				  'Resize','off',...
				  'NumberTitle','off',...
				  'Menubar','none',...
				  'HandleVisibility','off',...
				  'Name',paletteName);
					  
% Create Data Storage Space for the Palette
% MDDatObjs(1): matrix of handles of patches and text  
% 			 objects for the tools in the palette
% MDDatObjs(2): Currently selected tool
%
% Initialize other data objects in callback

	eval(['global ' GlobalName]);
	eval([GlobalName '.CurrentTool = 0;']);
	eval([GlobalName '.pfig = pfig;']);
	
	% Create the Palette axes
	
	pax = axes('Parent',pfig,'Position',[.05 .05 .9 .9],'Visible','off');
%	axes(pax);
	
	ptool = zeros(1,numberOfTools);
	ptext = zeros(1,numberOfTools);
	dy = 1/numberOfTools;
	yrange = 0:dy:1-dy;
	for(i=1:length(yrange))
		ptool(i) = patch('Parent',pax,...
						 'XData',[0 1 1 0 0],...
		                 'YData',yrange(i)+[0 0 dy dy 0],...
						 'ZData',-ones(1,5),...
						 'FaceColor',[1 1 1],...
						 'EdgeColor',[0 0 0],...
						 'ButtonDownFcn',['palette ' GlobalName ' ' callback]);
		ptext(i) = text('Parent',pax,...
						 'Position',[.5 yrange(i)+dy/2],...
		                'HorizontalAlignment','center',...
						'VerticalAlignment','middle',...
						'String',toolList(i),...
						'Color','k',...
						'ButtonDownFcn',['palette ' GlobalName ' ' callback]);
	end
	eval([GlobalName '.ToolList = [ptool; ptext];']);
	eval(callback);
else
	GlobalName = toolList;
	callback = paletteName;
	eval(['global ' GlobalName]);
	eval(['PData = ' GlobalName '.ToolList;']);
	eval(['tool = ' GlobalName '.CurrentTool;']);
	selectedTool = fix((find(gcbo == PData)-1)/2)+1;
	if(tool ~= 0)
		set(PData(1,tool),'FaceColor',[1 1 1]);
		set(PData(2,tool),'Color','k');
	end
	if(tool == selectedTool)
		selectedTool = '';	
		eval([GlobalName '.CurrentTool = 0;']);
	else
		set(PData(1,selectedTool),'FaceColor',[0 0 0]);
		set(PData(2,selectedTool),'Color','w');
		eval([GlobalName '.CurrentTool = selectedTool;']);
		selectedTool = get(PData(2,selectedTool),'String');
	end
	eval([callback '(selectedTool)']);
end
