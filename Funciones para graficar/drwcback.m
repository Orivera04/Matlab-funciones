function drwcback(command) 
% DRWCBACK Callback for Draw Tools Palette
% Function drwcback(command)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  7/97
 
% Copyright (c) 1997 by Keith Rogers

global MDDatObjs;
lastfig = gcf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Commands
%
%  None:    Initialize Data Objects
%  String:  Process command from palette
%  1:       Text tool WindowButtonDownFcn
%  1.1:       Callback for Text Edit UIControl
%  2:       Line tool WindowButtonDownFcn
%  2.1:       Line WindowButtonMotionFcn: Normal
%  2.2:       Line WindowButtonMotionFcn: Extend
%  2.3:       Line WindowButtonUpFcn
%  3:       Ellipse tool WindowButtonDownFcn
%  3.1:       Ellipse WindowButtonMotionFcn: Normal
%  3.2:       Ellipse WindowButtonMotionFcn: Extend
%  3.3:       Ellipse WindowButtonMotionFcn: Alt
%  3.4:       Ellipse WindowButtonUpFcn
%  4:       Box WindowButtonDownFcn
%  4.1:       Box WindowButtonMotionFcn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(nargin < 1)  % Initialize drwcback Data Space

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MDDatObjs.SelectList: Currently selected object
% MDDatObjs.RefLoc: Reference Location
% MDDatObjs.Defaults: Defaults
%	Defaults.CirclePoints = Number of points in Circle
%   Defaults.SelectionColor = Selection Color
%   Defaults.FontName = Default TextFont
%   Defaults.FontSize = Default TextSize
%   Defaults.FontWeight = Default TextWeight
%   Defaults.FontAngle = Default TextAngle
%   Defaults.TextAlignment = Default Text Horizontal Alignment
%   Defaults.LineStyle = Default Line Style
%   Defaults.LineWidth = Default Line Width
%   Defaults.PenColor = Default Pen Color
%   Defaults.FillColor = Default Fill Color
%   Defaults.Arrow = Defaults for Arrows 
%                  (Length,Width,Baseangle,Tipangle,CrossDir)
%   Defaults.ArrowStyle = Arrow Style; '<','>','-',or 'x'
%   Defaults.SaveString = Save String
%   Defaults.PalettePos = Palette Position
% MDDatObjs.GenPurpHandle: general purpose handle space
% MDDatObjs.MenuList: Menu handles for enabling/disabling
% MDDatObjs.Undo: Undo Data
% MDDatObjs.UndoClipboard: Clipboard for Undo
% MDDatObjs.Clipboard: Clipboard
% MDDatObjs.GP2: 
% MDDatObjs.GP3: 
% MDDatObjs.UndoII: Undo Values II
% MDDatObjs.FigList: Figure List
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Look for Preferences file %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	eval('load mdprefs; MDDatObjs.Defaults = Defaults;','drwcback(5)');
	MDDatObjs.SelectList = [];
	MDDatObjs.GenPurpHandle = [];
	pfig = MDDatObjs.pfig;
	UndoList(1).obj = [];
	UndoList(1).prop = [];
	UndoList(1).val = [];
	MDDatObjs.Undo = UndoList;
	UClip = [];
	MDDatObjs.UndoClipboard = UClip;
	clipboard = [];
	MDDatObjs.Clipboard = clipboard;
	MDDatObjs.GP2 = [];
	MDDatObjs.GP3 = [];
	MDDatObjs.UndoII = [];
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the figure isn't in the list, add it             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if(isfield(MDDatObjs,'FigList'))
		figList = MDDatObjs.FigList;
		if(isempty(find(figList==lastfig)))		
			MDDatObjs.FigList = [figList;lastfig;]; 
		end					
	else	
			MDDatObjs.FigList = lastfig; 
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If COMMAND is a string, we're receiving data 
% from PALETTE(), and need to process it.
% 
% ''  means we've deselected a palette item
% '+' means we've gone into SELECT mode
% 'T' means we've gone into TEXT mode
% '/' means we've gone into LINE drawing mode
% '0' means we've gone into CIRCLE drawing mode
% '#' means we've gone into BOX drawing mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(isstr(command))                          
	FigList = MDDatObjs.FigList;
	allfigs = get(0,'children');
	for(i=1:length(allfigs))
		if(~isempty(find(allfigs(i) == FigList)))
			break;
		elseif(i==length(allfigs))
			error('MatDraw is not active in any of the visible figures!');
		end
	end
	if(~isempty(command))
		figure(allfigs(i));
	end
	if(isempty(command))
		set(allfigs(i),'Pointer','arrow',...
					   'WindowButtonDownFcn','',...
					   'WindowButtonUpFcn','',...
					   'WindowButtonMotionFcn','');
	elseif(command=='T')
		set(allfigs(i),'Pointer','botl','WindowButtonDownFcn','drwcback(1)');
	elseif(command=='/')
		set(allfigs(i),'Pointer','crosshair','WindowButtonDownFcn','drwcback(2)');	
	elseif(command=='+')
		set(allfigs(i),'WindowButtonDownFcn','select',...
		               'Pointer','arrow');	
	elseif(command=='O')
		set(allfigs(i),'WindowButtonDownFcn','drwcback(3)',...
							'Pointer','circle');
	elseif(command=='#')
		set(allfigs(i),'WindowButtonDownFcn','drwcback(4)',...
							'Pointer','cross');
	end
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% If a tool other than the select tool %
	% is chosen, then deselect everything  %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	if(~isempty(command) & command ~= '+')
		SelectList = MDDatObjs.SelectList;
		for(i=1:size(SelectList,1))
			if(ishandle(SelectList(i,1)))
				set(SelectList(i,1),'Selected','off');
				typ = get(SelectList(i,1),'Type');
				if(strcmp(typ,'line'))
					set(SelectList(i,1),'Color',SelectList(i,2:4));
				elseif(strcmp(typ,'patch'))
					if(SelectList(i,2) == -1)
						set(SelectList(i,1),'EdgeColor','none');
					elseif(SelectList(i,2) == -2)
						set(SelectList(i,1),'EdgeColor','flat');
					elseif(SelectList(i,2) == -3)
						set(SelectList(i,1),'EdgeColor','interp');
					else
						set(SelectList(i,1),'EdgeColor',SelectList(i,2:4));
					end						
				end
			end
		end
		MDDatObjs.SelectList = [];
	end
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Text Placing Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 1)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Create Text ButtonDown
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Defaults = MDDatObjs.Defaults;
	cp = get(gca,'currentpoint');
	tobj = text('String','',...
		 'Units','data',...
		 'Position',cp(1,1:2),...
		 'HorizontalAlignment',Defaults.TextAlignment,...
		 'VerticalAlignment','bottom',...
		 'Color',Defaults.PenColor);
	set(tobj,'editing','on');
	UndoList = MDDatObjs.Undo;
	UndoList(1).obj = tobj;
	UndoList(1).prop = 'Delete';
	UndoList(2:end) = [];
	MDDatObjs.Undo = UndoList;
	set(gcf,'WindowButtonDownFcn','set(gcf,''WindowButtonDownFcn'',''drwcback(1)'')');

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Line drawing functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 2)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Line Drawing ButtonDown
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	hold on;
	axis(axis);
	ax = axis;
	if(length(ax) == 4)
		cp = get(gca,'CurrentPoint');
		obj = line('XData',[cp(1,1);cp(1,1)],'YData',[cp(1,2);cp(1,2)],...
				   'Color',MDDatObjs.Defaults.PenColor,...
				   'Linestyle',MDDatObjs.Defaults.LineStyle,...
				   'Marker',MDDatObjs.Defaults.Marker,...
				   'Linewidth',MDDatObjs.Defaults.LineWidth);
		set(obj,'Erasemode','xor');

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% If shift key his held down, limit
		% line angle to multiples of pi/12
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		if(strcmp(get(gcf,'SelectionType'),'extend'))
			set(gcf,'WindowButtonMotionFcn','drwcback(2.2)');
		else
			set(gcf,'WindowButtonMotionFcn','drwcback(2.1)');
		end
		set(gcf,'WindowButtonUpFcn','drwcback(2.3)');
		MDDatObjs.GenPurpHandle =obj;
	else
		set(gcf,'WindowButtonUpFcn','drwcback(2.4)');
		pick3d('3D Create Line');
	end

elseif(command == 2.1)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Line Drawing Normal ButtonMotion
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	obj = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	xd = get(obj,'XData');
	xd(2) = cp(1,1);
	yd = get(obj,'YData');
	yd(2) = cp(1,2);
	set(obj,'XData',xd,'YData',yd);

elseif(command == 2.2)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Line Drawing Extended ButtonMotion
	% (Round angles to multiples of pi/12)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	obj = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	XData = get(obj,'XData');
	YData = get(obj,'YData');
	ax = axis;
	dx = ax(2)-ax(1);
	dy = ax(4)-ax(3);
	NX = XData/dx;
	NY = YData/dy;
	
	s32 = .5*sqrt(3);
	s22 = .5*sqrt(2);
	Pmat = [1.0  0.0;  s32  0.5;  s22  s22;  0.5  s32;
	        0.0  1.0; -0.5  s32; -s22  s22; -s32  0.5;
	       -1.0  0.0; -s32 -0.5; -s22 -s22; -0.5 -s32;
	        0.0 -1.0;  0.5 -s32;  s22 -s22;  s32 -0.5];
	proj = Pmat*[cp(1,1)/dx-NX(1);cp(1,2)/dy-NY(1)];
	[m,i] = max(proj);
	m = m*Pmat(i,:);
	XData(2) = XData(1)+m(1)*dx;
	YData(2) = YData(1)+m(2)*dy;
	set(obj,'XData',XData,'YData',YData);

elseif(command == 2.3)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% ButtonUp for Lines and Boxes
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  	obj = MDDatObjs.GenPurpHandle;
	set(gcf,'WindowButtonMotionFcn','');
	set(gcf,'WindowButtonUpFcn','');
	set(obj,'EraseMode','normal');
	if(strcmp(get(obj,'Type'),'line'))
		Defaults = MDDatObjs.Defaults;
		ArrowDefs = Defaults.ArrowDefs;
		ArrowStyle = Defaults.ArrowStyle;
		if(ArrowStyle == '>')
			obj = arrow(obj,'Width',ArrowDefs(2),...
					  'Length',ArrowDefs(1),...
			          'BaseAngle',ArrowDefs(3),...
					  'TipAngle',ArrowDefs(4),...
					  'Normdir',ArrowDefs(5:7));
		elseif(ArrowStyle == '<')
			obj = arrow(obj,'Width',ArrowDefs(2),...
					  'Length',ArrowDefs(1),...
			        'BaseAngle',ArrowDefs(3),...
					  'TipAngle',ArrowDefs(4),...
					  'Ends','start',...
					  'Normdir',ArrowDefs(5:7));
		elseif(ArrowStyle == 'x')
			obj = arrow(obj,'Width',ArrowDefs(2),...
					  'Length',ArrowDefs(1),...
			        'BaseAngle',ArrowDefs(3),...
					  'TipAngle',ArrowDefs(4),...
					  'Ends','both',...
					  'Normdir',ArrowDefs(5:7));
		end
	end
	UndoList = MDDatObjs.Undo;
	UndoList(1).obj = obj;
	UndoList(1).prop = 'Delete';
	UndoList(2:end) = [];
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button up for first point in 3D line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 2.4)
	obj = line('XData',MDDatObjs.PickData.Point.x*[1 1],...
	           'YData',MDDatObjs.PickData.Point.y*[1 1],...
			   'ZData',MDDatObjs.PickData.Point.z*[1 1],...
				  'Color',MDDatObjs.Defaults.PenColor);
	set(obj,'Erasemode','xor');
	MDDatObjs.PickData.LineData.Handle = obj;
	MDDatObjs.PickData.LineData.Data = [MDDatObjs.PickData.Point.x*[1 1]; ...
										MDDatObjs.PickData.Point.y*[1 1]; ...
										MDDatObjs.PickData.Point.z*[1 1]];

	MDDatObjs.PickData.LineData.Start = 2;
	set(gcf,'WindowButtonUpFcn','drwcback(2.5)');
	pick3d('3D Create Line');
elseif(command == 2.5)
  	obj = gco;
	set(gcf,'WindowButtonMotionFcn','');
	set(gcf,'WindowButtonUpFcn','');
	set(obj,'EraseMode','normal');
	Defaults = MDDatObjs.Defaults;
	ArrowDefs = Defaults.ArrowDefs;
	ArrowStyle = Defaults.ArrowStyle;
	if(ArrowStyle == '>')
		obj = arrow(obj,'Width',ArrowDefs(2),...
				  'Length',ArrowDefs(1),...
		          'BaseAngle',ArrowDefs(3),...
				  'TipAngle',ArrowDefs(4),...
				  'Normdir',ArrowDefs(5:7));
	elseif(ArrowStyle == '<')
		obj = arrow(obj,'Width',ArrowDefs(2),...
				  'Length',ArrowDefs(1),...
		        'BaseAngle',ArrowDefs(3),...
				  'TipAngle',ArrowDefs(4),...
				  'Ends','start',...
				  'Normdir',ArrowDefs(5:7));
	elseif(ArrowStyle == 'x')
		obj = arrow(obj,'Width',ArrowDefs(2),...
				  'Length',ArrowDefs(1),...
		        'BaseAngle',ArrowDefs(3),...
				  'TipAngle',ArrowDefs(4),...
				  'Ends','both',...
				  'Normdir',ArrowDefs(5:7));
	end
	UndoList = MDDatObjs.Undo;
	UndoList(1).obj = obj;
	UndoList(1).prop = 'Delete';
	UndoList(2:end) = [];
	MDDatObjs.Undo = UndoList;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Circle/Ellipse Drawing functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 3)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Ellipse Drawing ButtonDown
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	numpts = MDDatObjs.Defaults.CirclePoints;
	hold on;
	axis(axis);
	cp = get(gca,'CurrentPoint');
	obj = patch('XData',cp(1,1)*ones(numpts,1),...
				'YData',cp(1,2)*ones(numpts,1),...
				'LineWidth',MDDatObjs.Defaults.LineWidth,...
				'FaceColor',MDDatObjs.Defaults.FillColor,...
				'EdgeColor',MDDatObjs.Defaults.PenColor,...
				'Erasemode','xor');
	if(strcmp(get(gcf,'SelectionType'),'extend'))
		set(gcf,'WindowButtonMotionFcn','drwcback(3.2)');
	elseif(strcmp(get(gcf,'SelectionType'),'alt'))
		set(gcf,'WindowButtonMotionFcn','drwcback(3.3)');
	else
		set(gcf,'WindowButtonMotionFcn','drwcback(3.1)');
	end
	set(gcf,'WindowButtonUpFcn','drwcback(3.4)');
	MDDatObjs.RefLoc = cp;
 	MDDatObjs.GenPurpHandle = obj;

elseif(command == 3.1) 
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Draw Ellipse from edge
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	firstpoint = MDDatObjs.RefLoc;
 	obj = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	ax = axis;
	numpts = MDDatObjs.Defaults.CirclePoints;
	ext = [min([cp(:,1:2);firstpoint(:,1:2)]) ...
		   abs(cp(1,1:2)-firstpoint(1,1:2))];
	[x,y] = ellipse(ext,numpts,ax);
	set(obj,'XData',x,'YData',y);
elseif(command == 3.2)  
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Draw Circle from edge
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	firstpoint = MDDatObjs.RefLoc;
 	obj = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	maxd = max(abs(cp(1,1:2)-firstpoint(1,1:2)));
	ext = [min([cp(:,1:2);firstpoint(:,1:2)]) maxd maxd];
	numpts = MDDatObjs.Defaults.CirclePoints;
	ax = axis;
	[x,y] = ellipse(ext,numpts,ax);
	set(obj,'XData',x,'YData',y);
elseif(command == 3.3)  
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Draw Circle from Center
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	center = MDDatObjs.RefLoc;
 	obj = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	ax = axis;
	radius = sqrt(((cp(1,1)-center(1,1))/(ax(2)-ax(1)))^2+((cp(1,2)-center(1,2))/(ax(4)-ax(3)))^2);
	ext = [center(1,1:2)-[radius radius] 2*radius 2*radius];
	numpts = MDDatObjs.Defaults.CirclePoints;
	[x,y] = ellipse(ext,numpts,ax);
	set(obj,'XData',x,'YData',y);
elseif(command == 3.4)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Ellipse ButtonUp
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 	obj = MDDatObjs.GenPurpHandle;
	set(obj,'EraseMode','normal',...
			'Tag','MDEllipse');
	set(gcf,'WindowButtonMotionFcn','');
	set(gcf,'WindowButtonUpFcn','');
	UndoList = MDDatObjs.Undo;
	UndoList(1).obj = obj;
	UndoList(1).prop = 'Delete';
	UndoList(2:end) = [];
	MDDatObjs.Undo = UndoList;
			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Box drawing functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 4)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Box Drawing ButtonDown
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	hold on;
	axis(axis);
	cp = get(gca,'CurrentPoint');
	obj = patch('XData',cp(1,1)*ones(4,1),...
				'YData',cp(1,2)*ones(4,1),...
				'FaceColor',MDDatObjs.Defaults.FillColor,...
				'Linewidth',MDDatObjs.Defaults.LineWidth,...
				'EdgeColor',MDDatObjs.Defaults.PenColor,...
				'Tag','MDBox',...
				'Erasemode','xor');
	set(gcf,'WindowButtonMotionFcn','drwcback(4.1)');
	set(gcf,'WindowButtonUpFcn','drwcback(2.3)');
	MDDatObjs.RefLoc = cp;
 	MDDatObjs.GenPurpHandle = obj;
elseif(command == 4.1)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Box Drawing ButtonDown
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	firstpoint = MDDatObjs.RefLoc;
	obj = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	ext = [firstpoint(1,1:2) cp(1,1:2)-firstpoint(1,1:2)];
	XData = ext(1)+[0 ext(3) ext(3) 0 0];
	YData = ext(2)+[0 0 ext(4) ext(4)  0];
	set(obj,'XData',XData,'YData',YData);	
	
elseif(command == 5)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Catch Failed Loading of Preferences %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	choice = questdlg(['Couldn''t load preferences file mdprefs.mat!' ...
	          '  Create new file or locate existing file?'], ...
			  'Missing Preferences','    New    ','    Locate    ','    Cancel    ','    New    ');
	switch choice
		case '    New    ',
		Defaults.CirclePoints = 50;
		Defaults.SelectionColor = [.5 .5 .5];
		Defaults.FontName = get(0,'DefaultTextFontName');
		Defaults.FontSize = get(0,'DefaultTextFontsize');
		Defaults.FontWeight = get(0,'DefaultTextFontWeight');
		Defaults.FontAngle = get(0,'DefaultTextFontAngle');
		Defaults.TextAlignment = get(0,'DefaultTextHorizontalAlignment');
		Defaults.LineStyle = get(0,'DefaultLineLineStyle');
		Defaults.Marker = get(0,'DefaultLineMarker');
		Defaults.MarkerPenColor = [0 0 0];
		Defaults.MarkerFillColor = [0 0 0];
		Defaults.LineWidth = get(0,'DefaultLineLineWidth');
		Defaults.PenColor = [0 0 0];
		Defaults.FillColor = 'None';
		Defaults.ArrowDefs = [16 1 90 16 NaN NaN NaN];
		Defaults.ArrowStyle = '-';
		Defaults.SaveString = '-deps';
		Defaults.PalettePos = [0 1];
		[filename,filepath] = uiputfile('mdprefs.mat','Save Preferences As:');
		if(filename)
			save([filepath filename],'Defaults');
		else
			warndlg('The preferences have not been saved!');
		end
		MDDatObjs.Defaults = Defaults;
	case '    Locate    ',
		disp('Locate')
		[filename,filepath] = uigetfile('mdprefs.mat','Locate MatDraw preferences file:');
		if(filename)
			eval(['load(' filepath filename ');'],'drwcback(5)');
		else
			error('MatDraw needs preferences to run!');
		end
	otherwise
		disp(choice);
		error('MatDraw needs preferences to run!');
	end
	MDDatObjs.Defaults = Defaults;
end


function [XData,YData] = ellipse(extent,numpts,axlims)
%ELLIPSE Draw an ellipse
%H = ELLIPSE(EXTENT,NUMPTS,AXLIMS)
%Draws an ellipse in the rectangle specfified by EXTENT
%returning handle H to the line object. If a value is 
%given for AXLIMS, the EXTENT is assumed to be in axis-
%normalized components, and the ellipse will be scaled
%accordingly.
%
%[XDATA,YDATA] = ELLIPSE(EXTENT,NUMPTS,AXLIMS)
%does not plot the ellipse, instead returning the X and
%Y Data
%
%NUMPTS defaults to 50 if not specified.
%
%Keith Rogers 11/94

if(nargin < 3)
	axlims = [0 1 0 1];
	if(nargin < 2)
		numpts = 50;
	end
end
center = extent(1:2)+.5*extent(3:4);
a = extent(3)/2/(axlims(2)-axlims(1));
b = extent(4)/2/(axlims(4)-axlims(3));
theta = 0:2*pi/(numpts-1):2*pi;
radius = a*b./sqrt(a^2+(b^2-a^2)*cos(theta).^2);
XData = center(1)+radius.*cos(theta)*(axlims(2)-axlims(1));
YData = center(2)+radius.*sin(theta)*(axlims(4)-axlims(3));
if(nargout < 2)
	XData = plot(XData,YData);
end;
