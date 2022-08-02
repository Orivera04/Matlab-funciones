function dmncback(command,option)
% DMNCBACK Callback for Draw Menu
% Function dmncback(command,option)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  11/94

% Mods:
%     12/02/94 Shortened name to appease DOS users
%     12/5/94  Adapted to deal with single palette for all
%              figures,changed name to lower case to
%              appease VMS users.
%     12/14/94 Add Delete item callback
%     12/15/94 Fixed bugs.
%     12/20/94 When deleting an object, delete its 
%              SelectLine as well.
%     12/28/94 Add support for UISetcolor or Other
%              colors using the input function for
%              those not on Macs or PC's.
%              Also fixed things so if we undo the
%              creation of an object after selecting
%              it we reset the SelectedObject
%      01/5/95 Change from using "input" to "prmptdlg"
%
% Copyright (c) 1995 by Keith Rogers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Commands
%
%  1:	Set LineStyle of selected object to OPTION
%  2:	Set LineWidth of selected object to OPTION;
%       if 0, get LineWidth from Prompter Dialog box
%  3:   Set Pen Color of selected object to OPTION;
%       "Other" brings up a color picker on Mac and PC	
%  4:   Set Fill Color of selected object to OPTION;
%       "Other" brings up a color picker on Mac and PC	
%  5:	Undo last change (disabled if undo not possible)
%  6:	Delete selected object	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global MDDatObjs;
UndoList = MDDatObjs.Undo;
SelectList = MDDatObjs.SelectList;
numObjs = size(SelectList,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Line Style Menu
%  
%  Option is a line style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch(command)
case {'LineStyle','Marker'}

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set Defaults if no object selected
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(numObjs == 0)
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
		eval(['MDDatObjs.Defaults.' command ' = option;']);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Main Stuff:
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(numObjs == 1)	
		if(strcmp(get(SelectList(1),'Type'),'line'))
			UndoList(1).obj = SelectList(1);
			UndoList(1).prop = command;
			UndoList(1).val = get(SelectList(1),command);
			UndoList(2:end) = [];
			set(SelectList(1),command,option);
		end
	else
		j = 1;
		for(i=1:numObjs)
			if(strcmp(get(SelectList(i,1),'Type'),'line'))
				UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = command;
				UndoList(j).val = get(SelectList(i,1),command);
				set(SelectList(i,1),command,option);
				j = j+1;
			end
		end
		UndoList(j:end) = [];
	end
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Line Width Menu
%  
%  Option is either a number 
%  (width in points) or 0 for
%  'Other'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case {'LineWidth','MarkerSize'}

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Deal with 'Other' Menu Item
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(option==0)
		if(strcmp(command,'LineWidth'))
			option = inputdlg('Line Width?','MatDraw',1,{.5});
		else
			option = inputdlg('MarkerSize?','MatDraw',1,{6});
		end
		if(isempty(option))
			return;
		end
		option = str2num(option{1});
		if(isempty(option))
			if(strcmp(command,'LineWidth'))
				warndlg('Line width must be a number!');
			else
				warndlg('Marker Size must be a number!');
			end
			return;
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set Defaults if no object selected
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(numObjs == 0)
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
		if(~isempty(findstr(get(menu,'Label'),'Other')))
			set(menu,'Label',['Other (' num2str(option) ')']);
		end
		if(strcmp(command,'LineWidth'))
			MDDatObjs.Defaults.LineWidth = option;
		else
			set(0,'DefaultLineMarkerSize',option);
		end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Main Stuff:
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(numObjs == 1)	
			type = get(SelectList(1),'Type');
			if(strcmp(type,'line') | strcmp(type,'patch'))
				UndoList(1).obj = SelectList(1);
				UndoList(1).prop = command;
				UndoList(1).val = get(SelectList(1),command);
				UndoList(2:end) = [];
				set(SelectList(1),command,option);
			end
	else
		j = 1;
		for(i=1:numObjs)
			type = get(SelectList(1),'Type');
			if(strcmp(type,'line') | strcmp(type,'patch'))
				UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = command;
				UndoList(j).val = get(SelectList(i,1),command);
				set(SelectList(i,1),command,option);
				j = j+1;
			end
		end
		UndoList(j:end) = [];
	end
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Pen Color Menu
%  
%  Option is one of
%    RGB Triple
%    'Other'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'PenColor'

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Deal with 'Other' Menu Item
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(strcmp(option,'Other'))
		option = choosecolor;
		if(option == 0)
			return;
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set Defaults if no object selected
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(numObjs == 0)
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
		if(~isempty(findstr(get(menu,'Label'),'Other')))
			set(menu,'Label',['Other (' num2str(option) ')']);
		end
		MDDatObjs.Defaults.PenColor = option;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Main Stuff:
	% 
	% Behavior is different for lines,
	% patches, and text. What a pain! 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	elseif(numObjs == 1)	
		UndoList(1).obj = SelectList(1);
		type = get(SelectList(1),'Type');
		if(strcmp(type,'line'))
			UndoList(1).prop = 'Color';
			UndoList(1).val = SelectList(2:4);
			set(SelectList(1),'Color',option,'Selected','off');
			MDDatObjs.SelectList = [];
		elseif(strcmp(type,'text'))
			UndoList(1).prop = 'Color';
			UndoList(1).val = get(SelectList(1),'Color');
			set(SelectList(1),'Color',option);
		elseif(strcmp(type,'patch'))
			UndoList(1).prop = 'EdgeColor';
			UndoList(1).val = SelectList(2:4);
			set(SelectList(1),'EdgeColor',option,'Selected','off');
			MDDatObjs.SelectList = [];
		end
		UndoList(2:end) = [];
	else
		j = 1;
		for(i=1:size(SelectList,1))
			type = get(SelectList(i,1),'Type');
			if(strcmp(type,'line')) 
			   UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'Color';
				UndoList(j).val = SelectList(i,2:4);
				SelectList(i,2:4) = option;
% 				set(SelectList(i,1),'Color',option,'Selected','off');
% 				SelectList = SelectList(find(SelectList(:,1)~=SelectList(i,1)),:);
				j = j+1;
			elseif(strcmp(type,'text'))
			   UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'Color';
				UndoList(j).val = get(SelectList(i,1),'Color');
				set(SelectList(i,1),'Color',option);
				j = j+1;
			elseif(strcmp(type,'patch'))
			   UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'EdgeColor';
				UndoList(j).val = SelectList(i,2:4);
				SelectList(i,2:4) = option;
% 				set(SelectList(i,1),'EdgeColor',option,'Selected','off');
% 				SelectList = SelectList(find(SelectList(:,1)~=SelectList(i,1)),:);
				j = j+1;
			end
		end
		MDDatObjs.SelectList = SelectList;
		UndoList(j:end) = [];
	end
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Marker Pen Color Menu
%  
%  Option is one of
%    RGB Triple
%    'Other'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'MarkerPenColor'

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Deal with 'Other' Menu Item
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(strcmp(option,'Other'))
		option = choosecolor;
		if(option == 0)
			return;
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set Defaults if no object selected
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(numObjs == 0)
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
		if(~isempty(findstr(get(menu,'Label'),'Other')))
			set(menu,'Label',['Other (' num2str(option) ')']);
		end
		MDDatObjs.Defaults.MarkerPenColor = option;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Main Stuff:
	% 
	% Behavior is different for lines,
	% patches, and text. What a pain! 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	elseif(numObjs == 1)	
		UndoList(1).obj = SelectList(1);
		type = get(SelectList(1),'Type');
		if(strcmp(type,'line') | strcmp(type,'patch'))
			UndoList(1).prop = 'MarkerEdgeColor';
			UndoList(1).val = SelectList(2:4);
			set(SelectList(1),'MarkerEdgeColor',option,'Selected','off');
			MDDatObjs.SelectList = [];
		end
		UndoList(2:end) = [];
	else
		j = 1;
		for (i = 1:size(SelectList,1))
			type = get(SelectList(i,1),'Type');
			if(strcmp(type,'line') | strcmp(type,'patch')) 
			   UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'MarkerEdgeColor';
				UndoList(j).val = SelectList(i,2:4);
				set(SelectList(i,1),'Color',option,'Selected','off');
				SelectList = SelectList(find(SelectList(:,1)~=SelectList(i,1)),:);
				j = j+1;
			end
		end
		MDDatObjs.SelectList = SelectList;
		UndoList(j:end) = [];
	end
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Fill Color Menu
%  
%  Option is one of
%    RGB Triple
%    'None'
%    'Other'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'FillColor'

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Deal with 'Other' Menu Item
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(strcmp(option,'Other'))
		option = choosecolor;
		if(option == 0)
			return;
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set Defaults if no object selected
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(numObjs == 0)
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
		if(~isempty(findstr(get(menu,'Label'),'Other')))
			set(menu,'Label',['Other (' num2str(option) ')']);
		end
		MDDatObjs.Defaults.FillColor = option;

	%%%%%%%%%%%%%%%
	% Main Stuff
	%%%%%%%%%%%%%%%
	
	elseif(numObjs == 1)	
		if(strcmp(get(SelectList(1,1),'type'),'patch'))
			UndoList(1).obj = SelectList(1);
			UndoList(1).prop = 'FaceColor';
			UndoList(1).val = get(SelectList(1),'FaceColor');
			UndoList(2:end) = [];
			set(SelectList(1),'FaceColor',option);
		elseif(strcmp(get(SelectList(1,1),'type'),'axes'))
			UndoList(1).obj = SelectList(1);
			UndoList(1).prop = 'Color';
			UndoList(1).val = get(SelectList(1),'Color');
			UndoList(2:end) = [];
			set(SelectList(1),'Color',option);
		end
	else
		j = 1;
		for(i=1:numObjs)
			if(strcmp(get(SelectList(i,1),'type'),'patch'))
				UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'FaceColor';
				UndoList(j).val = get(SelectList(i,1),'FaceColor');
				set(SelectList(i,1),'FaceColor',option);
				j = j+1;
			elseif(strcmp(get(SelectList(i,1),'type'),'axes'))
				UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'Color';
				UndoList(j).val = get(SelectList(i,1),'Color');
				UndoList(2:end) = [];
				set(SelectList(i,1),'Color',option);
				j = j+1;
			end
		end
		UndoList(j:end) = [];
	end
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Marker Fill Color Menu
%  
%  Option is one of
%    RGB Triple
%    'None'
%    'Other'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'MarkerFillColor'

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Deal with 'Other' Menu Item
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(strcmp(option,'Other'))
		option = choosecolor;
		if(option == 0)
			return;
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set Defaults if no object selected
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(numObjs == 0)
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
		if(~isempty(findstr(get(menu,'Label'),'Other')))
			set(menu,'Label',['Other (' num2str(option) ')']);
		end
		MDDatObjs.Defaults.MarkerFillColor = option;

	%%%%%%%%%%%%%%%
	% Main Stuff
	%%%%%%%%%%%%%%%
	
	elseif(numObjs == 1)
		type = get(SelectList(1,1),'type');	
		if(strcmp(type,'patch') | strcmp(type,'line'))
			UndoList(1).obj = SelectList(1);
			UndoList(1).prop = 'MarkerFaceColor';
			UndoList(1).val = get(SelectList(1),'MarkerFaceColor');
			UndoList(2:end) = [];
			set(SelectList(1),'MarkerFaceColor',option);
		end
	else
		j = 1;
		for(i=1:numObjs)
			if(strcmp(get(SelectList(i,1),'type'),'patch') | strcmp(type,'line'))
				UndoList(j).obj = SelectList(i,1);
				UndoList(j).prop = 'MarkerFaceColor';
				UndoList(j).val = get(SelectList(i,1),'MarkerFaceColor');
				set(SelectList(i,1),'MarkerFaceColor',option);
				j = j+1;
			end
		end
		UndoList(j:end) = [];
	end
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Arrow Menu
%
%  Option can be:
%  '>'  Arrow at end
%  '-'  No Arrow
%  '<'  Arrow at start
%  'x'  Arrow at both ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'Arrow'
	ArrowDefs = MDDatObjs.Defaults.ArrowDefs;
	if(numObjs == 0)
		MDDatObjs.Defaults.ArrowStyle = option;
		menu = gcbo;
		Mom = get(menu,'Parent');
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',gcbo);
		set(menu,'Checked','on');
	end
	for(i=1:numObjs)
		if(strcmp(get(SelectList(i,1),'Type'),'line'))
			if(option == '>')
				SelectList(i,1) = arrow(SelectList(i,1),...
										'Length',ArrowDefs(1),...
										'Width',ArrowDefs(2),...
										'BaseAngle',ArrowDefs(3),...
										'TipAngle',ArrowDefs(4),...
										'FaceColor',SelectList(i,2:4));
			elseif(option == '<')
				SelectList(i,1) = arrow(SelectList(i,1),...
										'Length',ArrowDefs(1),...
										'Width',ArrowDefs(2),...
										'BaseAngle',ArrowDefs(3),...
										'TipAngle',ArrowDefs(4),...
										'Ends','start',...
										'FaceColor',SelectList(i,2:4));
			elseif(option == 'x')
				SelectList(i,1) = arrow(SelectList(i,1),...
										'Length',ArrowDefs(1),...
										'Width',ArrowDefs(2),...
										'BaseAngle',ArrowDefs(3),...
										'TipAngle',ArrowDefs(4),...
										'Ends','both',...
										'FaceColor',SelectList(i,2:4));
			end
		elseif(strcmp(get(SelectList(i,1),'Tag'),'Arrow'))
			if(option == '>')
				SelectList(i,1) = arrow(SelectList(i,1),...
										'Length',ArrowDefs(1),...
										'Width',ArrowDefs(2),...
										'BaseAngle',ArrowDefs(3),...
										'TipAngle',ArrowDefs(4));
			elseif(option == '-')
				xdata = get(SelectList(i,1),'XData');
				ydata = get(SelectList(i,1),'YData');
				zdata = get(SelectList(i,1),'ZData');
				if(isempty(ZData))
					ZData = zeros(size(XData));
				end
				obj = SelectList(i,1);
				SelectList(i,1) = line('xdata',[xdata(6) xdata(1)],'zdata',[zdata(6) zdata(1)],'ydata',[ydata(6) ydata(1)]);
				if(strcmp(get(obj,'Type'),'line'))
					set(SelectList(i,1),'Color',get(obj,'Color'),...
					                    'LineStyle',get(obj,'LineStyle'));
				else
					set(SelectList(i,1),'Color',get(obj,'EdgeColor'));
				end
				delete(obj);
			elseif(option == '<')
				SelectList(i,1) = arrow(SelectList(i,1),...
										'Length',ArrowDefs(1),...
										'Width',ArrowDefs(2),...
										'BaseAngle',ArrowDefs(3),...
										'TipAngle',ArrowDefs(4),...
										'Ends','start');
			elseif(option == 'x')
				SelectList(i,1) = arrow(SelectList(i,1),...
										'Length',ArrowDefs(1),...
										'Width',ArrowDefs(2),...
										'BaseAngle',ArrowDefs(3),...
										'TipAngle',ArrowDefs(4),...
										'Ends','both');
			end
		end
	end
	if(numObjs)
		set(gcf,'CurrentObject',SelectList(i,1));
		MDDatObjs.SelectList = SelectList;
	end
case 'ArrowPrint'
	set(gcbo,'Checked','on');
	set(findobj(gcf,'Label','Auto Scale'),'Checked','off');
	Arrows = findobj(gcf,'Tag','Arrow');
	arrow(Arrows,'Page',1);
case 'ArrowScale'
	set(gcbo,'Checked','on');
	set(findobj(gcf,'Label','Print Scale'),'Checked','off');
	Arrows = findobj(gcf,'Tag','Arrow');
	arrow(Arrows,'Page',0);
case 'Forward'
	SelectedObjects = SelectList(:,1);
	ParentList = getParents(SelectedObjects);
	for(i=1:length(ParentList))
		kids = get(ParentList(i),'Children');
		[SelectedKids,ia,ib] = intersect(kids,SelectedObjects);
		for(j=sort(ia))
			if(j>1 & isempty(find(kids(j-1) == SelectedObjects)))
				kids([j-1 j]) = kids([j j-1]);
			end
		end
		set(ParentList(i),'Children',kids);
	end
case 'Back'
	SelectedObjects = SelectList(:,1);
	ParentList = getParents(SelectedObjects);
	for(i=1:length(ParentList))
		kids = get(ParentList(i),'Children');
		[SelectedKids,ia,ib] = intersect(kids,SelectedObjects);
		ia = sort(ia);
		for(j=ia(end:-1:1))
			if(j<length(kids) & isempty(find(kids(j+1) == SelectedObjects)))
				kids([j+1 j]) = kids([j j+1]);
			end
		end
		set(ParentList(i),'Children',kids);
	end
case 'SendToFront'
	SelectedObjects = SelectList(:,1);
	ParentList = getParents(SelectedObjects);	
	for(i=1:length(ParentList))
		kids = get(ParentList(i),'Children');
		[junk,ia,ib] = intersect(kids,SelectedObjects);
		ia = sort(ia);
		kidlist = kids;
		for(j=1:length(ia))
			[junk,inds] = setdiff(kidlist(j:end),kids(ia(j)));
			kidlist(j+1:end) = kidlist(sort(inds+j-1));
			kidlist(j) = kids(ia(j));
		end
		set(ParentList(i),'Children',kidlist);
	end
case 'SendToBack'
	SelectedObjects = SelectList(:,1);
	ParentList = getParents(SelectedObjects);
	for(i=1:length(ParentList))
		kids = get(ParentList(i),'Children');
		[junk,ia,ib] = intersect(kids,SelectedObjects);
		ia = sort(ia);
		kidlist = kids;
		for(j=1:length(ia))
			[junk,inds] = setdiff(kidlist(1:end-j+1),kids(ia(end-j+1)));
			kidlist(1:end-j) = kidlist(sort(inds));
			kidlist(end-j+1) = kids(ia(end-j+1));
		end
		set(ParentList(i),'Children',kidlist);
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get a list of the parents of the selected objects %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ParentList = getParents(SelectedObjects)
	Parents = get(SelectedObjects,'Parent');
	if(iscell(Parents))
		ParentList = Parents{1};
		if(length(Parents) > 1)
			for(i=2:length(Parents))
				if(isempty(find(Parents{i}) == ParentList))
					ParentList = [ParentList;Parents{i}];
				end
			end
		end
	else
		ParentList = Parents;
	end
