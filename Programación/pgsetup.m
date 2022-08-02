function pgsetup(command,subcommand);
%function pgsetup()
%
%Creates a dialog box which allows the user
%to customize the printing options for the
%current figure.  Most of the items should
%be self explanatory. A picture is drawn at
%the bottom of the figure showing the page
%and the positioning of the figure and its
%contents on it.  The smaller rectangles
%show the positioning of any axes that may
%exist. Click and drag on the edges of the
%rectangles to resize, and in the center
%to reposition.  Doing an 'alt' or 'extend'
%click will cause the click to apply to 
%the figure's patch even if the click is
%over one of the axes' patch.
%
%If the file PGhelp.m exists on your system,
%hitting the 'h' key while the mouse is over
%a uicontrol will cause an explanation of
%the control's function to be displayed at
%the command line.
%
%Keith Rogers 12/94

%Mods:
%  01/19/95   Turn off 'Resize' and 'NumberTitle' properties
%  07/26/96   Added in axes-related capabilities.
%
%Copyright (c) 1997 by Keith Rogers

if(nargin<1)
	ShrinkFactor = 3.7;					
	Background = .8*ones(1,3);
	Foreground = 'k';
	Widgetbground = .7*ones(1,3);
	Widgetfground = 'k';
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Create an axis if none exists %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	gca;
	
	fig = gcf;
	PSFigure = figure('Name','Page Setup',...
				      	'Units','Points',...
						'Position',[100 40 380 420],...
						'Resize','off',...
						'NumberTitle','off',...
					   	'Color',Background,...
					   	'WindowButtonDownFcn','pgsetup(''WindowButtonDown'')');
	if(exist('PShelp') == 2)
		set(PSFigure,'KeyPressFcn','PShelp');
	end
	PaperPosition = get(fig,'PaperPosition');
	PaperSize = get(fig,'PaperSize');
	%set(gca,'Visible','Off');
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','Margins',...
						'Position',[25 400 60 20]);
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','Bottom',...
						'HorizontalAlignment','Right',...
						'Position',[5 380 60 20]);
	uicontrol(PSFigure,'Style','Edit',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String',num2str(PaperPosition(2)),...
						'Position',[70 380 60 20],...
						'Tag','Bottom',...
						'Callback','pgsetup(''Margins'')');
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','Left',...
						'HorizontalAlignment','Right',...
						'Position',[5 355 60 20]);
	uicontrol(PSFigure,'Style','Edit',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String',num2str(PaperPosition(1)),...
						'Position',[70 355 60 20],...
						'Tag','Left',...
						'Callback','pgsetup(''Margins'')');
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','Top',...
						'HorizontalAlignment','Right',...
						'Position',[5 330 60 20]);
	uicontrol(PSFigure,'Style','Edit',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String',num2str(PaperSize(2)-PaperPosition(2)-PaperPosition(4)),...
						'Position',[70 330 60 20],...
						'Tag','Top',...
						'Callback','pgsetup(''Margins'')');
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','Right',...
						'HorizontalAlignment','Right',...
						'Position',[5 305 60 20]);
	uicontrol(PSFigure,'Style','Edit',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String',num2str(PaperSize(1)-PaperPosition(1)-PaperPosition(3)),...
						'Position',[70 305 60 20],...
						'Tag','Right',...
						'Callback','pgsetup(''Margins'')');
	
	
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','Paper Type',...
						'HorizontalAlignment','Left',...
						'Position',[150 400 100 20]);
	switch get(fig,'PaperType')
		case 'usletter',	val = 1;
		case 'uslegal',		val = 2;
		case 'a3',			val = 3;
		case 'a4letter',	val = 4;
		case 'a5',			val = 5;
		case 'a5',			val = 6;
		otherwise,			val = 7;
	end
	uicontrol(PSFigure,'Style','popupmenu',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','usletter|uslegal|a3|a4letter|a5|b4|tabloid',...
						'Value',val,...
						'Tag','PaperType',...
						'Callback','pgsetup(''PaperType'')',...
						'Position',[150 380 120 20]);
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'HorizontalAlignment','left',...
						'String','Paper Orientation',...
						'Position',[150 355 120 20]);
						
	switch get(fig,'PaperOrientation')
	 	case 'portrait', 	val = 1;
		case 'landscape',	val = 2;
		otherwise,			val = 3;
	end
	
	uicontrol(PSFigure,'Style','popupmenu',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','Portrait|Landscape|Tall',...
						'Tag','Orient',...
						'Value',val,...
						'Callback','pgsetup(''PSOrient'')',...
						'Position',[150 335 120 20]);
	uicontrol(PSFigure,'Style','checkbox',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Widgetfground,...
						'String','Invert Hardcopy',...
						'Tag','Invert',...
						'Value',strcmp(get(fig,'InvertHardCopy'),'on'),...
						'Callback','pgsetup(''Invert'')',...
						'Position',[150 305 130 20]);
	uicontrol(PSFigure,'Style','Text',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Foreground,...
						'String','PaperUnits',...
						'HorizontalAlignment','Left',...
						'Position',[270 400 90 20]);
						
	switch get(fig,'PaperUnits')
		case 'inches',		val = 1;
		case 'centimeters',	val = 2;
		case 'normalized', 	val = 3;
		otherwise,			val = 4;
	end
	
	uicontrol(PSFigure,'Style','popupmenu',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','inches|centimeters|normalized|points',...
						'Tag','PaperUnits',...
						'Value',val,...
						'Callback','pgsetup(''PaperUnits'')',...
						'Position',[280 380 90 20]);
	uicontrol(PSFigure,'Style','pushbutton',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','OK',...
						'Tag','OK',...
						'Callback','pgsetup(''OK'')',...
						'Position',[290 340 80 25]);
	uicontrol(PSFigure,'Style','pushbutton',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','Cancel',...
						'Tag','Cancel',...
						'Callback','pgsetup(''Cancel'')',...
						'Position',[290 305 80 25]);
	uicontrol(PSFigure,'Style','pushbutton',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','Apply',...
						'Tag','Apply',...
						'Callback','pgsetup(''PSApply'')',...
						'Position',[290 270 80 25]);
	uicontrol(PSFigure,'Style','pushbutton',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','Save',...
						'Tag','Save',...
						'Callback','pgsetup(''PSSave'')',...
						'Position',[200 270 80 25]);
	uicontrol(PSFigure,'Style','pushbutton',...
						'Units','Points',...
						'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'String','Print',...
						'Tag','Print',...
						'Callback','pgsetup(''PSPrint'')',...
						'Position',[110 270 80 25]);
	ppos = getset(fig,'paperposition','paperunits','inches');
	fpos = getset(fig,'position','units','inches');
	if(all(ppos(3:4)==fpos(3:4)))
		val = 1;
	else
		val = 0;
	end
	uicontrol(PSFigure,'Style','checkbox',...
						'Units','Points',...
						'BackgroundColor',Background,...
						'ForegroundColor',Widgetfground,...
						'String','WYSIWYG',...
						'Value',val,...
						'Tag','WYSIWYG',...
						'Position',[20 270 80 25]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the axes that shows the page. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	axes('Units',get(fig,'PaperUnits'),...
		 'Position',[.7 .25 PaperSize(1)/ShrinkFactor PaperSize(2)/ShrinkFactor],...
		 'box','on',...
		 'color','w',...
		 'xcolor','k',...
		 'ycolor','k')
	grid off;
	axis equal;
	axis([0 PaperSize(1) 0 PaperSize(2)]);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the patch that represents the
% figure on the page.
% Tag: FigPatch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[xdata,ydata] = rect2xy(PaperPosition);
	PatchObj = patch('Xdata',xdata,...
				 'Ydata',ydata,...
				 'EdgeColor','w',...
				 'FaceColor',Background,...
				 'Tag','FigPatch');
				 
	UserData = [fig;PatchObj;ShrinkFactor];
	set(gcf,'UserData',UserData);
	set(gcf,'PaperPosition',PaperPosition,...
			'PaperType',get(fig,'PaperType'),...
			'PaperOrientation',get(fig,'PaperOrientation'),...
			'PaperUnits',get(fig,'PaperUnits'));
	axis(axis);
	hold on;

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up globals:
% PGaxpos     --  Positions of axes in target figure
%                 in normalized coordinates
% PGaxlist    --  Contains the handles of the 
%                 axes in the target figure.
% PGaxpatches --  Contains the handles of the patches
%                 used to represent the axes of the 
%                 target figure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	global PGaxpos PGaxlist PGaxpatches;
	PGaxlist = findobj(fig,'type','axes');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% numaxes is the number of axes in the 
	% target figure.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	numaxes = length(PGaxlist);
	PGaxpos = zeros(numaxes,4);
	PGaxpatches = zeros(numaxes,1);
	for(i=1:numaxes)
		PGaxpos(i,:) = getset(PGaxlist(i),'position','units','normalized');
		[xdata,ydata] = rect2xy(subrect(PaperPosition,PGaxpos(i,:)));
		PGaxpatches(i)= patch('Xdata',xdata,...
		  				  'Ydata',ydata,...
						  'Zdata',5*ones(size(xdata)),...
						  'edgecolor',Widgetfground,...
						  'facecolor',Widgetbground,...
						  'Tag','AxPatch');
	end

elseif(nargin == 1)
	eval(command);
else
	eval([command '(' num2str(subcommand) ');']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DrawPage called from:    Calls:
%   Margins                  AdjustAxes
%   Orient
%   PaperUnits
%          
%	PaperPosition, PaperSize, PaperUnits
%   may have changed.  Adjust the Page Axes
%   and Figure Patch to match new values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DrawPage 

	%%%%  Get the necessary information  %%%%
	
	UserData = get(gcf,'UserData');
	PatchObj = UserData(2);
	ShrinkFactor = UserData(3);	
	PaperPosition = get(gcf,'PaperPosition');
	PaperUnits = get(gcf,'PaperUnits');
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Make sure axis units reflect the units
	% which have been selected in the popupmenu.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	set(gca,'units',PaperUnits);	
	PaperSize = get(gcf,'PaperSize');
	set(gcf,'PaperUnits',PaperUnits);
	AxPos = get(gca,'Position');
	set(gca,'Position',[AxPos(1) AxPos(2) PaperSize(1)/ShrinkFactor PaperSize(2)/ShrinkFactor]);
	set(gca,'Units',PaperUnits);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% For 'normalized' paper units, we don't want 'axis equal',
	% but for any other paper units, we do.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(strcmp(PaperUnits,'normalized'))
		axis('normal');
		axis([0 1 0 1]);
	else
		axis('equal');
		PaperSize = get(gcf,'PaperSize');
		axis([0 PaperSize(1) 0 PaperSize(2)]);
	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Adjust the Figure Patch %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%

	[Xdata,Ydata] = rect2xy(PaperPosition);	
	set(PatchObj,'EraseMode','Xor',...
				'XData',Xdata,...
				'YData',Ydata);
	set(PatchObj,'EraseMode','Normal');
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Now adjust the Axes Patches %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	AdjustAxes;
	
	%%%%%%%%%%%%%%%%%%%%%%%
	% Fix the axis limits % 
	%%%%%%%%%%%%%%%%%%%%%%%
	axis(axis);
	hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called by WindowButtonDownFcn
% Sets the WindowButtonMotionFcn to Corner, Side, or Move
% depending on the location of the click relative to the 
% Active Patch.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Resize 
	UserData = get(gcf,'UserData');
	PatchObj = UserData(2);  % Get the Active Patch
	global PGaxpatches;
	ext = xy2rect(get(PatchObj,'XData'),get(PatchObj,'YData'));

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Store extent for use of WindowButtonMotionFcn
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	set(PatchObj,'UserData',ext);  
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% If the Active Patch is the Figure Patch
	% make the Axes Patches invisible 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if(strcmp(get(PatchObj,'Tag'),'FigPatch'))
		set(PGaxpatches,'visible','off');
	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Get location of click relative to the Active Patch
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	cp = get(gca,'CurrentPoint');
	cp = (cp(1,1:2)-ext(1:2))./ext(3:4);

	margin = 0.2;
	if(cp(1)<margin)
		if(cp(2)<margin) 		% Lower Left Corner
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Corner'',1)');
		elseif(cp(2)>1-margin) 	% Upper Left Corner
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Corner'',2)');
		else								% Left Side
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Side'',1)');
		end
	elseif(cp(1)>1-margin)
		if(cp(2)<margin) 		% Lower Right Corner
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Corner'',4)');
		elseif(cp(2)>1-margin) 	% Upper Right Corner
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Corner'',3)');
		else								% Right Side
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Side'',3)');
		end
	elseif(cp(2)>1-margin)		% Top Side
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Side'',2)')
	elseif(cp(2)<margin)		% Bottom Side
			set(gcf,'WindowButtonMotionFcn','pgsetup(''Side'',4)')
	else									% Center
		set(gca,'UserData',get(gca,'CurrentPoint'));
		set(gcf,'WindowButtonMotionFcn','pgsetup(''Move'')');
	end
	set(PatchObj,'erasemode','xor');
	set(gcf,'WindowButtonUpFcn','pgsetup(''Up'')');
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called by WindowButtonMotionFcn
% Resize the Active Patch from a corner:
%   Subcommand 1  ==>  Lower Left
%   Subcommand 2  ==>  Upper Left
%   Subcommand 3  ==>  Upper Right
%   Subcommand 4  ==>  Lower Right
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Corner(subcommand)
	UserData = get(gcf,'UserData');
	PatchObj = UserData(2);
	cp = get(gca,'CurrentPoint');
	ext = get(PatchObj,'UserData');
	switch subcommand
		case 1, ext = [cp(1,1:2) ext(1:2)+ext(3:4)-cp(1,1:2)];
		case 2, ext = [cp(1,1) ext(2) ext(1)+ext(3)-cp(1,1) cp(1,2)-ext(2)];
		case 3,	ext(3:4) = cp(1,1:2)-ext(1:2);
		case 4, ext(2:4) = [cp(1,2) cp(1,1)-ext(1) ext(2)+ext(4)-cp(1,2)];
	end
	[XData,YData] = rect2xy(ext);
	set(PatchObj,'XData',XData,'YData',YData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called by WindowButtonMotionFcn
% Resize the Active Patch from a side:
%   Subcommand 1  ==>   Left
%   Subcommand 2  ==>   Top
%   Subcommand 3  ==>   Right
%   Subcommand 4  ==>   Bottom
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Side(subcommand)
	UserData = get(gcf,'UserData');
	PatchObj = UserData(2);
	cp = get(gca,'CurrentPoint');
	ext = get(PatchObj,'UserData');
	switch subcommand
		case 1, ext = [cp(1,1) ext(2) ext(1)+ext(3)-cp(1,1) ext(4)];
		case 2, ext = [ext(1) ext(2) ext(3) cp(1,2)-ext(2)];
		case 3, ext = [ext(1) ext(2) cp(1,1)-ext(1) ext(4)];
		case 4, ext = [ext(1) cp(1,2) ext(3) ext(2)+ext(4)-cp(1,2)];
	end
	[XData,YData] = rect2xy(ext);
	set(PatchObj,'XData',XData,'YData',YData);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called by WindowButtonMotionFcn
% Move the Active Patch.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Move 
	UserData = get(gcf,'UserData');
	PatchObj = UserData(2);
	startpoint = get(gca,'UserData');
	cp = get(gca,'CurrentPoint');
	XData = get(PatchObj,'XData');
	YData = get(PatchObj,'YData');
	XData = XData+cp(1,1)-startpoint(1,1);
	YData = YData+cp(1,2)-startpoint(1,2);
	set(PatchObj,'XData',XData,'YData',YData);
	set(gca,'UserData',cp);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called by WindowButtonUpFcn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Up
	UserData = get(gcf,'UserData');
	PatchObj = UserData(2);
	set(PatchObj,'EraseMode','normal');
	set(gcf,'WindowButtonMotionFcn','',...
			'WindowButtonUpFcn','');
	if(strcmp(get(PatchObj,'Tag'),'FigPatch'))
		PaperSize = get(gcf,'PaperSize');
		global PGaxpatches;
		set(PGaxpatches,'visible','on');
		ext = xy2rect(get(PatchObj,'XData'),get(PatchObj,'YData'));
		set(gcf,'PaperPosition',ext);
		set(findobj(gcf,'Tag','Bottom'),'String',num2str(ext(1)));
		set(findobj(gcf,'Tag','Left'),'String',num2str(ext(2)));
		set(findobj(gcf,'Tag','Top'),'String',num2str(PaperSize(2)-ext(2)-ext(4)));
		set(findobj(gcf,'Tag','Right'),'String',num2str(PaperSize(1)-ext(1)-ext(3)));
	else
		global PGaxpatches PGaxpos
		thisPatch = find(PGaxpatches==PatchObj);
		PGaxpos(thisPatch,:) = xy2rect(get(PatchObj,'XData'),get(PatchObj,'YData'));	
		FigPatch = findobj(gcf,'Tag','FigPatch');
		ext = xy2rect(get(FigPatch,'XData'),get(FigPatch,'YData'));
		PGaxpos(thisPatch,1) = (PGaxpos(thisPatch,1)-ext(1))/(ext(3));
		PGaxpos(thisPatch,2) = (PGaxpos(thisPatch,2)-ext(2))/(ext(4));
		PGaxpos(thisPatch,3) = PGaxpos(thisPatch,3)/(ext(3));
		PGaxpos(thisPatch,4) = PGaxpos(thisPatch,4)/(ext(4));

	end
	AdjustAxes;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called from:   Top, Left, Bottom, Right EDIT UICONTROLS
% Calls:         DrawPage
%
% Sets the PaperPosition to the values from the uicontrols
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Margins 
	PaperSize = get(gcf,'PaperSize');
	Bottom = str2num(get(findobj(gcf,'Tag','Bottom'),'String'));
	Left = str2num(get(findobj(gcf,'Tag','Left'),'String'));
	Top = str2num(get(findobj(gcf,'Tag','Top'),'String'));
	Right = str2num(get(findobj(gcf,'Tag','Right'),'String'));
	set(gcf,'PaperPosition',[Left ...
									 Bottom ...
									 PaperSize(1)-Left-Right ...
									 PaperSize(2)-Bottom-Top]);
	DrawPage

function Invert
	if(get(findobj(gcf,'Tag','Invert'),'Value'))
		set(gcf,'InvertHardCopy','on');
	else
		set(gcf,'InvertHardCopy','off');
	end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called from:  PaperUnits POPUPMENU UICONTROL
% Calls: DrawPage
%
% Sets PaperUnits, updates margin uicontrols to match.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function PaperUnits
	switch get(findobj(gcf,'Tag','PaperUnits'),'Value')
		case 1, set(gcf,'PaperUnits','Inches');
		case 2, set(gcf,'PaperUnits','Centimeters');
		case 3, set(gcf,'PaperUnits','Normalized');
		case 4, set(gcf,'PaperUnits','Points');
	end
	PaperSize = get(gcf,'PaperSize');
	PaperPosition = get(gcf,'PaperPosition');
	set(findobj(gcf,'Tag','Left'),'String',...
		num2str(PaperPosition(1)));
	set(findobj(gcf,'Tag','Right'),'String',...
		num2str(PaperSize(1)-PaperPosition(1)-PaperPosition(3)));
	set(findobj(gcf,'Tag','Top'),'String',...
		num2str(PaperSize(2)-PaperPosition(2)-PaperPosition(4)));
	set(findobj(gcf,'Tag','Bottom'),'String',...
		num2str(PaperPosition(2)));
	DrawPage;
	
function PaperType
	UserData = get(gcf,'UserData');
	switch get(findobj(gcf,'Tag','PaperType'),'Value')
		case 1, 
			set(gcf,'PaperType','usletter');
			UserData(3) = 3.5;
			set(gcf,'UserData',UserData);
		case 2, 
			set(gcf,'PaperType','uslegal');
			UserData(3) = 4;
			set(gcf,'UserData',UserData);
		case 3, 
			set(gcf,'PaperType','a3');
			UserData(3) = 5;
			set(gcf,'UserData',UserData);
		case 4, 
			set(gcf,'PaperType','a4letter');
			UserData(3) = 3.5;
			set(gcf,'UserData',UserData);
		case 5, 
			set(gcf,'PaperType','a5');
			UserData(3) = 2.5;
			set(gcf,'UserData',UserData);
		case 6, 
			set(gcf,'PaperType','b4');
			UserData(3) = 4;
			set(gcf,'UserData',UserData);
		otherwise,
			set(gcf,'PaperType','tabloid');
			UserData(3) = 5;
			set(gcf,'UserData',UserData);
	end
	Margins;

function AdjustAxes
	global PGaxpatches PGaxpos;
	FigPatch = findobj(gcf,'Tag','FigPatch');
	rect = xy2rect(get(FigPatch,'Xdata'),get(FigPatch,'Ydata'));
	set(PGaxpatches,'EraseMode','xor');
	for(i=1:length(PGaxpatches))
		[xdata,ydata] = rect2xy(subrect(rect,PGaxpos(i,:)));
		set(PGaxpatches(i),'xdata',xdata,'ydata',ydata);
	end
	set(PGaxpatches,'EraseMode','Normal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called by:  Orient POPUPMENU UICONTROL
% Calls:      DrawPage
%
% Changes PaperPosition, PaperSize, adjusts
% Margins to match.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PSOrient
	switch get(findobj(gcf,'Tag','Orient'),'Value')
		case 1, orient portrait;
		case 2, orient landscape;
		case 3, orient tall;
	end
	ext = get(gcf,'PaperPosition');
	PaperSize = get(gcf,'PaperSize');
	set(findobj(gcf,'Tag','Bottom'),'String',num2str(ext(1)));
	set(findobj(gcf,'Tag','Left'),'String',num2str(ext(2)));
	set(findobj(gcf,'Tag','Top'),'String',num2str(PaperSize(2)-ext(2)-ext(4)));
	set(findobj(gcf,'Tag','Right'),'String',num2str(PaperSize(1)-ext(1)-ext(3)));
	DrawPage;
function PSApply
	UserData = get(gcf,'UserData');
	fig = UserData(1);
	set(fig,'PaperUnits',get(gcf,'PaperUnits'));
	set(fig,'PaperType',get(gcf,'PaperType'));
	set(fig,'PaperOrientation',get(gcf,'PaperOrientation'));
	set(fig,'PaperPosition',get(gcf,'PaperPosition'));
	set(fig,'InvertHardCopy',get(gcf,'InvertHardCopy'));
	global PGaxpos PGaxlist
	for(i=1:length(PGaxlist))
		set(PGaxlist(i),'Units','Normalized','Position',PGaxpos(i,:));
	end
	if(get(findobj(gcf,'Tag','WYSIWYG'),'Value') == 1)
		figure(fig);
		wysiwyg;
	else
		figure(fig);
	end
	disp('Axes can be accessed through the global PGaxlist');

function OK
	PSApply
	delete(findobj('Type','figure','Name','Page Setup'));

function PSSave
	[filename,pathname] = uiputfile('template.m','Save template as:');
	if(exist([pathname filename]) == 2 & ~strcmp(computer,'MAC2'))
		if(strcmp(questdlg(['Overwrite ' filename '?'],'Yes','No'),'No'))
			return;
		end
	end
	[fd,message] = fopen([pathname filename],'w');
	if(fd == -1)
		error(message);
	end
	Write(fd);
    fclose(fd);
	
function PSPrint
	Write(1);

function Write(fd)
	fprintf(fd,'clf;\n\n');
	fprintf(fd,'set(gcf,''PaperUnits'',''%s'',...\n',get(gcf,'PaperUnits'));
	fprintf(fd,'        ''PaperType'',''%s'',...\n',get(gcf,'PaperType'));
	fprintf(fd,'        ''PaperOrientation'',''%s'',...\n',get(gcf,'PaperOrientation'));
	fprintf(fd,'        ''PaperPosition'',[%f %f %f %f],...\n',get(gcf,'PaperPosition'));
	fprintf(fd,'        ''InvertHardCopy'',''%s'');\n\n',get(gcf,'InvertHardCopy'));
    global PGaxpos;
    for(i=1:size(PGaxpos,1))
    	fprintf(fd,['Ax%d = axes(''Units'',''Normalized'',' ...
    	            '''Position'',[%f %f %f %f]);\n'],i,PGaxpos(i,:));
    end
function Cancel
	delete(gcf);
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Called whenever user clicks in the figure
% Calls  Resize if click is within the Figure Patch
%
% Processes clicks; sets Active Patch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
function WindowButtonDown
	global PGaxpos PGaxlist PGaxpatches

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	% UserData(2) holds the handle of the Active Patch
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	
	UserData = get(gcf,'UserData');
	
	FigPatch = findobj(gcf,'Tag','FigPatch');
	pos = get(gca,'currentpoint');
	ext = xy2rect(get(FigPatch,'XData'),get(FigPatch,'YData'));

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	% Calculate the position of the click relative to the Figure Patch 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

	pos = (pos(1,1:2)-ext(1:2))./ext(3:4); 
	
%	keyboard;                          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	if(all(pos>0) & all(pos < [1 1]))  % If the click is inside the Figure Patch
		UserData(2) = FigPatch;        % make the Figure Patch the Active Patch.
		                               % This is a "default" setting.		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% If the click was not a normal click, then ignore the Axes Patches;
		% otherwise, if the click is inside one of the Axes Patches
		% make that Axes Patch the Active Patch.
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		if(strcmp(get(gcf,'SelectionType'),'normal'))
			for(i=1:length(PGaxlist))
				if(pos(1) > PGaxpos(i,1) & pos(1) < PGaxpos(i,1)+PGaxpos(i,3) &...
				   pos(2) > PGaxpos(i,2) & pos(2) < PGaxpos(i,2)+PGaxpos(i,4))
					UserData(2) = PGaxpatches(i);
					break;
				end
			end
		end 
		set(gcf,'UserData',UserData);
		Resize;
	end

function [xdata,ydata] = rect2xy(box)
%function [xdata,ydata] = rect2xy([left bottom width height])
% Returns x and y coordinates of the vertices of a 
% rectangle specified in MATLAB's lbwh format.

	xdata = box(1)+[0 0 box(3) box(3)];
	ydata = box(2)+[0 box(4) box(4) 0];

function rect = xy2rect(xdata,ydata)
%function rect = xy2rect(xdata,ydata)
%Convert a list of vertices matching a 
%rectangle to MATLAB's lbwh rectangle format

	rect(1) = min(xdata);
	rect(2) = min(ydata);
	rect(3) = max(xdata)-rect(1);
	rect(4) = max(ydata)-rect(2);
	
function rect = subrect(rect1,rect2)
%function rect = subrect(rect1,rect2)
%returns a rect ([left bottom width height])
%in frame of rect1 if rect2 is in normalized 
%coordinates in terms of rect1.

rect(1:2) = rect1(1:2)+rect1(3:4).*rect2(1:2);
rect(3:4) = rect1(3:4).*rect2(3:4);

