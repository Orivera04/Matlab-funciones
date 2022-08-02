function mdprog(command)
% MATDRAW  adds menus and draw functions to Matlab
% MATDRAW()
% Adds a suite of menus and a Draw palette to
% the Matlab environment.  This is an extension
% of the earlier package matmenus, which was
% written in November of 1993.
% 
% This version of MatDraw requires MATLAB version 5 or higher
%
% Keith Rogers 6/97

% Copyright (c) 1997 by Keith Rogers

% Really before ANYTHING else, make sure 
% ShowHiddenHandles is turned off
ShowHiddenHandles = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','off');

% Before anything else, turn off SelectionHighlight
% for lines and patches.

set(findobj(gcf,'type','line'),'SelectionHighlight','off');
set(gcf,'DefaultLineSelectionHighlight','off');
set(gcf,'DefaultPatchSelectionHighlight','off');

% First off, create the Draw Tools Palette

if(nargin < 1)
	fig = gcf;
	figure(fig);
	set(fig,'Pointer','watch');
	
% Compile everything
	if(0)
		axcback;dmncback;drwcback;edtcback;figcback;
		findfig;kdialog;labels;loadobj;pick3d;mdzoom;movetext;
		objsize;palette;pgsetup;prmptdlg;saveobj;select;streamer;
		textlen;txtcback;viewer;vwrcback;wrkcback;zoom3d;
	end	
	global MDDatObjs;
	if(isstruct(MDDatObjs) & ishandle(MDDatObjs.pfig))
		figList = MDDatObjs.FigList;
		if(find(figList==fig))
			menuList = MDDatObjs.MenuList;
			if(ishandle(menuList(find(figList==fig),1)))
				error('MatDraw is already active in this  window!');
			end
			menuList = menuList(find(figList~=fig),:);
			figList = figList(find(figList~=fig));
			MDDatObjs.FigList = figList;
			MDDatObjs.MenuList = menuList;
		end
		figure(MDDatObjs.pfig);
		drwcback;
	else
		palette('#O/T+','Draw Tools','drwcback','MDDatObjs');
		set(MDDatObjs.pfig,'DeleteFcn','mdprog(1)');
	end
	figure(fig);
	mdprog(3);
elseif(command == 3)
	fig = gcf;
	global MDDatObjs;
	Defaults = MDDatObjs.Defaults;
	pfig = MDDatObjs.pfig;
	MDDatObjs.PickData = [];

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set the Palette Position %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	PalettePos = Defaults.PalettePos;
	Units = get(pfig,'Units');
	set(pfig,'Units','Normalized');
	pos = get(pfig,'Position');
	set(pfig,'Position',[PalettePos(1) PalettePos(2)-pos(4) pos(3:4)]);
	set(pfig,'Units',Units);


	set(fig,'KeyPressFcn','select(11)',...
			'MenuBar','none');
	eval('set(fig,''ResizeFcn'',''mdprog(2)'')','');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% WORKSPACE MENU
	%
	% wrkcback commands
	% 1:	Load 
	% 2:	Save
	% 3:	Save As
	% 4:	New Figure
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	workspace = uimenu('Label','Workspace','Tag','MatDrawMenu');
	uimenu(workspace,'Label','New Figure', 'Callback','wrkcback',...
		'Accelerator','N');
	uimenu(workspace,'Label','Load', 'Callback','wrkcback');
	uimenu(workspace,'Label','Save Workspace', 'Callback','wrkcback',...
		'Accelerator','S');
	uimenu(workspace,'Label','Save Figure', 'Callback','wrkcback');
	uimenu(workspace,'Label','Save As', 'Callback','wrkcback',...
		'Accelerator','A');
	uimenu(workspace,'Label','Add to Path','Callback','wrkcback');
	uimenu(workspace,'Label','Print','Callback','wrkcback',...
		'Accelerator','P');
	uimenu(workspace,'Label','Preferences','Callback','mddefs');
	uimenu(workspace,'Label','Quit MatDraw', 'Callback','wrkcback',...
		'Accelerator','Q','Separator','on');
	

	%%%%%%%%%%%%%%%%
	% MDEDIT Menu
	%
	% edtcback commands
	% 1:	Undo 
	% 2:	Cut
	% 3:	Copy
	% 4:	Paste
	%%%%%%%%%%%%%%%%

	EditMenu = uimenu('Label','MDEdit','Tag','MatDrawMenu');
	UndoMenu = uimenu(EditMenu,'Label','Undo','Callback','edtcback(1)','Accelerator','Z');
	uimenu(EditMenu,'Label','Cut','Callback','edtcback(2)','Accelerator','X');
	uimenu(EditMenu,'Label','Copy','Callback','edtcback(3)','Accelerator','C');
	uimenu(EditMenu,'Label','Paste','Callback','edtcback(4)','Accelerator','V');
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% TEXT Menu
	% For txtcback the command parameter is 
	% 1:	Set font
	% 2:	Set angle
	% 3:	Set weight
	% 4:    Set to plain
	% 5:	Set Size
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	TextMenu = uimenu('Label','Text','Tag','MatDrawMenu');
	FontMenu = uimenu(TextMenu,'Label','Font');
	StyleMenu = uimenu(TextMenu,'Label','Style');
	SizeMenu = uimenu(TextMenu,'Label','Size');
	AlignMenu = uimenu(TextMenu,'Label','Alignment');

	%%%%%%%%%%%%%
	% Font Menu
	%%%%%%%%%%%%%

	fontfile = fopen('sys.fnt','r');
	if(fontfile == -1)
		error('Can''t read file ''sys.fnt''');
	end

	fontname = fgetl(fontfile);
	while(fontname ~= -1)
		uimenu(FontMenu,'Label',fontname, ...
						'Callback',['txtcback(1,''' fontname ''')']);
		fontname = fgetl(fontfile);
	end
	fclose(fontfile);

	DefFont = Defaults.FontName;
	
	% If the default font is not in the user's "sys.fnt" file
	% then we have to add it manually.
	
	DefMen = findobj(FontMenu,'Label',DefFont);
	if(isempty(DefMen))
		set(FontMenu,'UserData',uimenu(FontMenu,'Label',DefFont,...
		'Callback',['txtcback(1,''' DefFont ''')'],'Checked','on'));
	else
		set(DefMen,'Checked','on');
		set(FontMenu,'UserData',DefMen);
	end
	

	%%%%%%%%%%%%%
	% Style Menu
	%%%%%%%%%%%%%

	pmenu = uimenu(StyleMenu,'Label','Plain','Callback','txtcback(4,''plain'')');
	uimenu(StyleMenu,'Label','Italic','Callback','txtcback(2,''italic'')');
	uimenu(StyleMenu,'Label','Oblique','Callback','txtcback(2,''oblique'')');
	uimenu(StyleMenu,'Label','Light','Callback','txtcback(3,''light'')');
	uimenu(StyleMenu,'Label','Demi','Callback','txtcback(3,''demi'')');
	uimenu(StyleMenu,'Label','Bold','Callback','txtcback(3,''bold'')');
	DefAngle = Defaults.FontAngle;
	DefWeight = Defaults.FontWeight;
	AMenu = findobj(StyleMenu,'Label',DefAngle);
	WMenu = findobj(StyleMenu,'Label',DefWeight);
	if(~isempty(AMenu))
		set(AMenu,'Checked','on');
		set(StyleMenu,'UserData',AMenu);
	elseif(isempty(WMenu))
		set(pmenu,'Checked','on','UserData',[]);
		set(StyleMenu,'UserData',pmenu);
	end
	if(~isempty(WMenu))
		set(WMenu,'Checked','on');
		set(pmenu,'UserData',WMenu);
	end

	%%%%%%%%%%%%%
	% Size Menu
	%%%%%%%%%%%%%

	uimenu(SizeMenu,'Label','6','Callback','txtcback(5,6)');
	uimenu(SizeMenu,'Label','9','Callback','txtcback(5,9)');
	uimenu(SizeMenu,'Label','12','Callback','txtcback(5,12)');
	uimenu(SizeMenu,'Label','14','Callback','txtcback(5,14)');
	uimenu(SizeMenu,'Label','18','Callback','txtcback(5,18)');
	uimenu(SizeMenu,'Label','24','Callback','txtcback(5,24)');
	OtherMenu = uimenu(SizeMenu,'Label','Other','Callback','txtcback(5,0)');
	DefSize = Defaults.FontSize;
	DefMenu = findobj(SizeMenu,'Label',num2str(DefSize));
	if(isempty(DefMenu))
		set(OtherMenu,'Label',['Other (' num2str(DefSize) ')'],...
					  'Checked','on');
		set(SizeMenu,'UserData',OtherMenu);
	else
		set(DefMenu,'Checked','on');
		set(SizeMenu,'UserData',DefMenu);
	end
	
	%%%%%%%%%%%%%%%%%%
	% Alignment Menu
	%%%%%%%%%%%%%%%%%%

	defMenu = uimenu(AlignMenu,'Label','Left','Callback','txtcback(6,''Left'')');
	uimenu(AlignMenu,'Label','Center','Callback','txtcback(6,''Center'')');
	uimenu(AlignMenu,'Label','Right','Callback','txtcback(6,''Right'')');
	DefMenu = findobj(AlignMenu,'Label',Defaults.TextAlignment);
	if(isempty(DefMenu))
		DefMenu = defMenu;
	end
	set(DefMenu,'Checked','on');
	set(AlignMenu,'UserData',DefMenu);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% DRAW Menu
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	DrawMenu = uimenu('Label','Draw','Tag','MatDrawMenu');
	LineStyleMenu = uimenu(DrawMenu,'Label','Line Style');
	MarkerMenu = uimenu(DrawMenu,'Label','Marker');
	LineWidthMenu = uimenu(DrawMenu,'Label','Line Width');
	PenColorMenu = uimenu(DrawMenu,'Label','Pen Color');
	FillColorMenu = uimenu(DrawMenu,'Label','Fill Color');
	ArrowMenu = uimenu(DrawMenu,'Label','Arrows');
    uimenu(DrawMenu,'Label','Back','Callback','dmncback Back');
	uimenu(DrawMenu,'Label','Forward','Callback','dmncback Forward');
	uimenu(DrawMenu','Label','Send to Back','Callback','dmncback SendToBack');
    uimenu(DrawMenu','Label','Send to Front','Callback','dmncback SendToFront');
	
    % Save the Menu Handles

	if(isfield(MDDatObjs,'MenuList'))
		MenuList = MDDatObjs.MenuList;
	else
		MenuList = [];
	end
	MenuList = [MenuList;
			    DrawMenu LineStyleMenu MarkerMenu...
			   	LineWidthMenu PenColorMenu ...
				FillColorMenu UndoMenu];
	MDDatObjs.MenuList = MenuList;

	%%%%%%%%%%%%%%%%%%
	% LineStyle Menu
	%%%%%%%%%%%%%%%%%%

	uimenu(LineStyleMenu,'Label','''-''','Callback','dmncback(''LineStyle'',''-'')','UserData','-');
	uimenu(LineStyleMenu,'Label',''':''','Callback','dmncback(''LineStyle'','':'')','UserData',':');
	uimenu(LineStyleMenu,'Label','''--''','Callback','dmncback(''LineStyle'',''--'')','UserData','--');
	uimenu(LineStyleMenu,'Label','''-.''','Callback','dmncback(''LineStyle'',''-.'')','UserData','-.');
	defmen = findobj(LineStyleMenu,'UserData',Defaults.LineStyle);
	set(defmen,'Checked','on');
	set(LineStyleMenu,'UserData',defmen);

	uimenu(MarkerMenu,'Label','None','Callback','dmncback(''Marker'',''None'')');
	uimenu(MarkerMenu,'Label','+','Callback','dmncback Marker +');
	uimenu(MarkerMenu,'Label','x','Callback','dmncback Marker x');
	uimenu(MarkerMenu,'Label','o','Callback','dmncback Marker o');
	uimenu(MarkerMenu,'Label','.','Callback','dmncback Marker .');
	uimenu(MarkerMenu,'Label','*','Callback','dmncback Marker *');
	uimenu(MarkerMenu,'Label','v','Callback','dmncback Marker v');
	uimenu(MarkerMenu,'Label','^','Callback','dmncback Marker ^');
	uimenu(MarkerMenu,'Label','>','Callback','dmncback Marker >');
	uimenu(MarkerMenu,'Label','<','Callback','dmncback Marker <');
	uimenu(MarkerMenu,'Label','Square','Callback','dmncback Marker Square');
	uimenu(MarkerMenu,'Label','Diamond','Callback','dmncback Marker Diamond');
	uimenu(MarkerMenu,'Label','Pentagram','Callback','dmncback Marker Pentagram');
	uimenu(MarkerMenu,'Label','Hexagram','Callback','dmncback Marker Hexagram');
	defmen = findobj(MarkerMenu,'Label',Defaults.Marker);
	set(defmen,'Checked','on');
	MarkerSizeMenu = uimenu(MarkerMenu,'Label','Size');
	MarkerPenColorMenu = uimenu(MarkerMenu,'Label','Pen Color');
	MarkerFillColorMenu = uimenu(MarkerMenu,'Label','Fill Color');
	set(LineStyleMenu,'UserData',defmen);

	%%%%%%%%%%%%%%%%%%%%%%%
	% Marker Size  Menu
	%%%%%%%%%%%%%%%%%%%%%%%

	uimenu(MarkerSizeMenu,'Label','6','Callback','dmncback(''MarkerSize'',6)');
	uimenu(MarkerSizeMenu,'Label','9','Callback','dmncback(''MarkerSize'',9)');
	uimenu(MarkerSizeMenu,'Label','12','Callback','dmncback(''MarkerSize'',12)');
	uimenu(MarkerSizeMenu,'Label','14','Callback','dmncback(''MarkerSize'',12)');
	uimenu(MarkerSizeMenu,'Label','18','Callback','dmncback(''MarkerSize'',12)');
	uimenu(MarkerSizeMenu,'Label','24','Callback','dmncback(''MarkerSize'',12)');
	OtherMenu = uimenu(MarkerSizeMenu,'Label','Other','Callback','dmncback(''MarkerSize'',0)');
	
	DefSize = get(0,'defaultlinemarkersize');
	DefMenu = findobj(MarkerSizeMenu,'Label',num2str(DefSize));
	if(isempty(DefMenu))
		set(OtherMenu,'Label',['Other (' num2str(DefSize) ')'],...
					  'Checked','on');
		set(MarkerSizeMenu,'UserData',OtherMenu);
	else
		set(DefMenu,'Checked','on');
		set(MarkerSizeMenu,'UserData',DefMenu);
	end
	

	%%%%%%%%%%%%%%%%%%%%%%%
	% Marker Pen Color Menu
	%%%%%%%%%%%%%%%%%%%%%%%

	uimenu(MarkerPenColorMenu,'Label','Yellow','Callback','dmncback(''MarkerPenColor'',[1 1 0])',...
	'ForegroundColor','y');
	uimenu(MarkerPenColorMenu,'Label','Magenta','Callback','dmncback(''MarkerPenColor'',[1 0 1])',...
	'ForegroundColor','m');
	uimenu(MarkerPenColorMenu,'Label','Cyan','Callback','dmncback(''MarkerPenColor'',[0 1 1])',...
	'ForegroundColor','c');
	uimenu(MarkerPenColorMenu,'Label','Red','Callback','dmncback(''MarkerPenColor'',[1 0 0])',...
	'ForegroundColor','r');
	uimenu(MarkerPenColorMenu,'Label','Green','Callback','dmncback(''MarkerPenColor'',[0 1 0])',...
	'ForegroundColor','g');
	uimenu(MarkerPenColorMenu,'Label','Blue','Callback','dmncback(''MarkerPenColor'',[0 0 1])',...
	'ForegroundColor','b');
	uimenu(MarkerPenColorMenu,'Label','White','Callback','dmncback(''MarkerPenColor'',[1 1 1])',...
	'ForegroundColor','w');
	uimenu(MarkerPenColorMenu,'Label','Black','Callback','dmncback(''MarkerPenColor'',[0 0 0])',...
	'ForegroundColor','k');
	other = uimenu(MarkerPenColorMenu,'Label','Other','Callback','dmncback(''MarkerPenColor'',''Other'')',...
	'ForegroundColor',[0.01 0.01 0.01]);
	defmen = findobj(MarkerPenColorMenu,'ForegroundColor',Defaults.MarkerPenColor);
	if(isempty(defmen))
		set(other,'ForegroundColor',Defaults.MarkerPenColor);
		defmen = findobj(MarkerPenColorMenu,'ForegroundColor',Defaults.MarkerPenColor);
	end
	set(defmen,'Checked','on');
	set(MarkerPenColorMenu','UserData',defmen);

	%%%%%%%%%%%%%%%%%%%%%%%%
	% Marker Fill Color Menu
	%%%%%%%%%%%%%%%%%%%%%%%%

	uimenu(MarkerFillColorMenu,'Label','Yellow','Callback','dmncback(''MarkerFillColor'',[1 1 0])',...
	'ForegroundColor','y');
	uimenu(MarkerFillColorMenu,'Label','Magenta','Callback','dmncback(''MarkerFillColor'',[1 0 1])',...
	'ForegroundColor','m');
	uimenu(MarkerFillColorMenu,'Label','Cyan','Callback','dmncback(''MarkerFillColor'',[0 1 1])',...
	'ForegroundColor','c');
	uimenu(MarkerFillColorMenu,'Label','Red','Callback','dmncback(''MarkerFillColor'',[1 0 0])',...
	'ForegroundColor','r');
	uimenu(MarkerFillColorMenu,'Label','Green','Callback','dmncback(''MarkerFillColor'',[0 1 0])',...
	'ForegroundColor','g');
	uimenu(MarkerFillColorMenu,'Label','Blue','Callback','dmncback(''MarkerFillColor'',[0 0 1])',...
	'ForegroundColor','b');
	uimenu(MarkerFillColorMenu,'Label','White','Callback','dmncback(''MarkerFillColor'',[1 1 1])',...
	'ForegroundColor','w');
	uimenu(MarkerFillColorMenu,'Label','Black','Callback','dmncback(''MarkerFillColor'',[0 0 0])',...
	'ForegroundColor','k');
	other = uimenu(MarkerFillColorMenu,'Label','Other','Callback','dmncback(''MarkerFillColor'',''Other'')',...
	'ForegroundColor',[0.01 0.01 0.01]);
	none = uimenu(MarkerFillColorMenu,'Label','None','Callback','dmncback(''MarkerFillColor'',''none'')',...
	'ForegroundColor',[0.01 0.01 0.01]);
	if(isstr(Defaults.MarkerFillColor))
		defmen = none;
	else
		defmen = findobj(MarkerFillColorMenu,'ForegroundColor',Defaults.MarkerFillColor);
		if(isempty(defmen))
			set(other,'ForegroundColor',Defaults.MarkerFillColor);
			defmen = findobj(MarkerFillColorMenu,'ForegroundColor',Defaults.MarkerFillColor);
		end
	end
	set(defmen,'Checked','on');
	set(FillColorMenu,'UserData',defmen);


	%%%%%%%%%%%%%%%%%%
	% Line Width Menu
	%%%%%%%%%%%%%%%%%%

	uimenu(LineWidthMenu,'Label','0.5 point','Callback','dmncback(''LineWidth'',.5)','UserData',.5);
	uimenu(LineWidthMenu,'Label','1.0 point','Callback','dmncback(''LineWidth'',1)','UserData',1);
	uimenu(LineWidthMenu,'Label','2.0 point','Callback','dmncback(''LineWidth'',2)','UserData',2);
	uimenu(LineWidthMenu,'Label','4.0 point','Callback','dmncback(''LineWidth'',4)','UserData',4);
	other = uimenu(LineWidthMenu,'Label','Other','Callback','dmncback(''LineWidth'',0)','UserData',1);
	defmen = findobj(LineWidthMenu,'UserData',Defaults.LineWidth);
	if(isempty(defmen))
		defmen = other;
	end
	set(defmen,'Checked','on');
	set(LineWidthMenu,'UserData',defmen);

	%%%%%%%%%%%%%%%%%%
	% Pen Color Menu
	%%%%%%%%%%%%%%%%%%

	uimenu(PenColorMenu,'Label','Yellow','Callback','dmncback(''PenColor'',[1 1 0])',...
	'ForegroundColor','y');
	uimenu(PenColorMenu,'Label','Magenta','Callback','dmncback(''PenColor'',[1 0 1])',...
	'ForegroundColor','m');
	uimenu(PenColorMenu,'Label','Cyan','Callback','dmncback(''PenColor'',[0 1 1])',...
	'ForegroundColor','c');
	uimenu(PenColorMenu,'Label','Red','Callback','dmncback(''PenColor'',[1 0 0])',...
	'ForegroundColor','r');
	uimenu(PenColorMenu,'Label','Green','Callback','dmncback(''PenColor'',[0 1 0])',...
	'ForegroundColor','g');
	uimenu(PenColorMenu,'Label','Blue','Callback','dmncback(''PenColor'',[0 0 1])',...
	'ForegroundColor','b');
	uimenu(PenColorMenu,'Label','White','Callback','dmncback(''PenColor'',[1 1 1])',...
	'ForegroundColor','w');
	uimenu(PenColorMenu,'Label','Black','Callback','dmncback(''PenColor'',[0 0 0])',...
	'ForegroundColor','k');
	uimenu(PenColorMenu,'Label','Other','Callback','dmncback(''PenColor'',''Other'')',...
	'ForegroundColor',[.01 .01 .01]);
	defmen = findobj(PenColorMenu,'ForegroundColor',Defaults.PenColor); 
	if(isempty(defmen))
		set(other,'ForegroundColor',Defaults.PenColor);
		defmen = findobj(PenColorMenu,'ForegroundColor',Defaults.PenColor);
	end
	set(PenColorMenu,'UserData',defmen);
	set(defmen,'Checked','on');

	%%%%%%%%%%%%%%%%%%
	% Fill Color Menu
	%%%%%%%%%%%%%%%%%%

	uimenu(FillColorMenu,'Label','Yellow','Callback','dmncback(''FillColor'',[1 1 0])',...
	'ForegroundColor','y');
	uimenu(FillColorMenu,'Label','Magenta','Callback','dmncback(''FillColor'',[1 0 1])',...
	'ForegroundColor','m');
	uimenu(FillColorMenu,'Label','Cyan','Callback','dmncback(''FillColor'',[0 1 1])',...
	'ForegroundColor','c');
	uimenu(FillColorMenu,'Label','Red','Callback','dmncback(''FillColor'',[1 0 0])',...
	'ForegroundColor','r');
	uimenu(FillColorMenu,'Label','Green','Callback','dmncback(''FillColor'',[0 1 0])',...
	'ForegroundColor','g');
	uimenu(FillColorMenu,'Label','Blue','Callback','dmncback(''FillColor'',[0 0 1])',...
	'ForegroundColor','b');
	uimenu(FillColorMenu,'Label','White','Callback','dmncback(''FillColor'',[1 1 1])',...
	'ForegroundColor','w');
	uimenu(FillColorMenu,'Label','Black','Callback','dmncback(''FillColor'',[0 0 0])',...
	'ForegroundColor','k');
	uimenu(FillColorMenu,'Label','Other','Callback','dmncback(''FillColor'',''Other'')',...
	'ForegroundColor',[0.01 0.01 0.01]);
	uimenu(FillColorMenu,'Label','None','Callback','dmncback(''FillColor'',''none'')',...
	'ForegroundColor',[0.01 0.01 0.01]);
	if(isstr(Defaults.FillColor))
		defmen = findobj(FillColorMenu,'Label','None');
	else
		defmen = findobj(FillColorMenu,'ForegroundColor',Defaults.FillColor); 
		if(isempty(defmen))
			set(other,'ForegroundColor',Defaults.FillColor);
			defmen = findobj(FillColorMenu,'ForegroundColor',Defaults.FillColor);
		end
	end
	set(FillColorMenu,'UserData',defmen);
	set(defmen,'Checked','on');

	%%%%%%%%%%%%%%%%%%
	% Arrow Menu
	%%%%%%%%%%%%%%%%%%

	uimenu(ArrowMenu,'Label',' ----->','Callback','dmncback(''Arrow'',''>'')','UserData','>');
	uimenu(ArrowMenu,'Label',' ------','Callback','dmncback(''Arrow'',''-'')','UserData','-');
	uimenu(ArrowMenu,'Label',' <-----','Callback','dmncback(''Arrow'',''<'')','UserData','<');
	uimenu(ArrowMenu,'Label',' <---->','Callback','dmncback(''Arrow'',''x'')','UserData','x');
	uimenu(ArrowMenu,'Label','Tips...','Callback','arrowdlg','separator','on');
	uimenu(ArrowMenu,'Label','Print Scale','Callback','dmncback(''ArrowPrint'')');
	uimenu(ArrowMenu,'Label','Auto Scale','Callback','dmncback(''ArrowAuto'')','Checked','on');
	defmen = findobj(ArrowMenu,'UserData',Defaults.ArrowStyle);
	set(defmen,'Checked','on');
	set(ArrowMenu,'UserData',defmen);

	%%%%%%%%%%%%%%%%
	% FIGURE Menu 
	%%%%%%%%%%%%%%%%

	FigMenu = uimenu('Label','Figure','Tag','MatDrawMenu','Callback','figcback(0)');
	uimenu(FigMenu,'Label','Page Setup','Callback','pgsetup');
	uimenu(FigMenu,'Label','WYSIWYG','Callback','figcback(3)');

	%%%%%%%%%%%%%%%%%
	% Colormap Menu
	%%%%%%%%%%%%%%%%%

	ColorMenu = uimenu(FigMenu,'Label','ColorMap');

	uimenu(ColorMenu,'Label','Default','Callback',...
		'colormap(''default'')');
	uimenu(ColorMenu,'Label','Gray','Callback',...
		'colormap(''gray'')');
	uimenu(ColorMenu,'Label','Hot','Callback',...
		'colormap(''hot'')');
	uimenu(ColorMenu,'Label','Cool','Callback',...
		'colormap(''cool'')');
	uimenu(ColorMenu,'Label','Copper','Callback',...
		'colormap(''copper'')');
	uimenu(ColorMenu,'Label','Pink','Callback',...
		'colormap(''pink'')');

	if(strcmp(computer,'MAC2') | strcmp(computer,'PCWIN'))
		MBarMenu = uimenu(FigMenu,'Label','Full Menus','Callback','figcback(1)','Separator','on');
	else
		MBarMenu = [];
	end
	set(FigMenu,'UserData',MBarMenu);
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% AXIS Menu
	%
	% axcback commands
	% 1:	Linear/Log toggle
	% 2:	AutoRange Min
	% 3:	AutoRange Max
	% 4:	Hold on/off toggle
	% 5: 	Axis Auto/Freeze toggle
	% 6:	Zoom Axis toggles
	% 7:	Zoom Magnification Level
	% 8: Expand/Reduce
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	AxMenu = uimenu('Label','Axis','Callback','axcback(0)','Tag','MatDrawMenu');
	uimenu(AxMenu,'Label','Labels','Callback','labels','Accelerator','L');
	uimenu(AxMenu,'Label','Expand','Callback','axcback(8)','Accelerator','E');
	uimenu(AxMenu,'Label','Clear','Callback','cla','Accelerator','K');
	uimenu(AxMenu,'Label','Grid','Callback','grid','Accelerator','G');

	autofreeze = uimenu(AxMenu,'Label','Freeze');

	%%%%%%%%%%%%%%
	% Aspect Menu
	%%%%%%%%%%%%%%

	AspectMenu = uimenu(AxMenu,'Label','Aspect');
	uimenu(AspectMenu,'Label','Normal','Callback','axis(''normal'')');
	uimenu(AspectMenu,'Label','Square','Callback','axis(''square'')');
	uimenu(AspectMenu,'Label','Image','Callback','axis(''image'')');
	uimenu(AspectMenu,'Label','Equal','Callback','axis(''equal'')');

	Xaxis = uimenu(AxMenu,'Label','X Opts');
	Yaxis = uimenu(AxMenu,'Label','Y Opts');
	Zaxis = uimenu(AxMenu,'Label','Z Opts');

	xloglin = uimenu(Xaxis,'Label','LogLin');
	yloglin = uimenu(Yaxis,'Label','LogLin');
	zloglin = uimenu(Zaxis,'Label','LogLin');
	uimenu(Xaxis,'Label','Auto Min','Callback','axcback(2,''X'')');
	uimenu(Xaxis,'Label','Auto Max','Callback','axcback(3,''X'')');
	uimenu(Yaxis,'Label','Auto Min','Callback','axcback(2,''Y'')');
	uimenu(Yaxis,'Label','Auto Max','Callback','axcback(3,''Y'')');
	uimenu(Zaxis,'Label','Auto Min','Callback','axcback(2,''Z'')');
	uimenu(Zaxis,'Label','Auto Max','Callback','axcback(3,''Z'')');

	holditem = uimenu(AxMenu,'Label','Hold');

	set(AxMenu,'UserData',[autofreeze;...
						   xloglin;...
						   yloglin;...
						   zloglin;...
						   holditem;]);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% ZOOM Menu
	%
	% UserData(1)     X axis zoom flag
	% UserData(2)     Y axis zoom flag
	% UserData(3)     Z axis zoom flag
	% UserData(4)     Magnification Level
	% UserData(5)     Direction Flag (1 = IN, 2 = OUT)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	ZoomMenu = uimenu(AxMenu,'Label','Zoom');

	MDDatObjs.ZoomData.X = 1;
	MDDatObjs.ZoomData.Y = 1;
	MDDatObjs.ZoomData.Z = 0;
	MDDatObjs.ZoomData.maglevel = 2;
	MDDatObjs.ZoomData.InOut = 1;
	MDDatObjs.ZoomData.Interruptible = 1;

	uimenu(ZoomMenu,'Label','Zoom In','Callback','mdzoom(''in'')',...
		'Accelerator','I');
	uimenu(ZoomMenu,'Label','Zoom Out','Callback','mdzoom(''out'')',...
		'Accelerator','O');
	uimenu(ZoomMenu,'Label','Zoom Home','Callback','mdzoom(''home'')',...
		'Accelerator','U');
	uimenu(ZoomMenu,'Label','X Axis','Checked','on',...
		'Callback','axcback(6,''X'')','Separator','on');
	uimenu(ZoomMenu,'Label','Y Axis','Checked','on',...
		'Callback','axcback(6,''Y'')');
	uimenu(ZoomMenu,'Label','Z Axis','Checked','off',...
		'Callback','axcback(6,''Z'')');
	uimenu(ZoomMenu,'Label',['Mag Level -' num2str(MDDatObjs.ZoomData.maglevel) '-'],'Callback','axcback(7,0)',...
		'Separator','on');

	uimenu(AxMenu,'Label','Viewer','Callback','viewer','Separator','on');
	
	set(gcf,'Pointer','arrow');
elseif(command == 1)
	allfigs = get(0,'Children');
	for (fig = allfigs)
		menus = findobj(fig,'Type','uimenu','Tag','MatDrawMenu');
		delete(menus);
	end
	set(allfigs,'Resizefcn','',...
			'WindowButtonDownFcn','',...
			'Keypressfcn','',...
			'Pointer','arrow',...
			'menubar','figure');
elseif(command == 2)
	   Arrows = findobj(gcf,'Tag','Arrow');
	   if(~isempty(Arrows))
			arrow(Arrows);
	   end
end

% Restore ShowHiddenHandles Setting
set(0,'ShowHiddenHandles',ShowHiddenHandles);
