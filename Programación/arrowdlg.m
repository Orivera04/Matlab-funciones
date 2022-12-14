function arrowdlg(command)
if(nargin < 1)
	global MDDatObjs;
	ArrowDefs = MDDatObjs.Defaults.ArrowDefs;
	BackgroundColor = .8*ones(1,3);
	ForegroundColor = 'k';
	Widgetbground = .7*ones(1,3);
	Widgetfground = 'k';
	figpos = [100 350 320 200];
	titlefig = figure('Units','Points',...
	                  'Color',BackgroundColor,...
	                  'Position',figpos,...
					  'Name','Arrows',...
					  'HandleVisibility','Callback',...
					  'Resize','off',...
					  'NumberTitle','off');
	set(titlefig,'DefaultUIControlFontSize',9)
	axis off;
	set(gca,'position',[0 0 1 1]);
	axis(axis);
	top = figpos(4);
	right = figpos(3);
	leftmargin = 10;
	topmargin = 30;
	vspace = 10;
	hspace = 5;
	edsize = objsize('edit',5);
	txtsize = textlen('Base Angle:');
	position = [leftmargin top-topmargin-edsize(2) txtsize(1) edsize(2)];
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'Style','text',...
						'String','Base Angle:',...
						'Units','points',...
						'Position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'Style','text',...
						'String','Tip Angle:',...
						'Units','points',...
						'Position',position);
	position = [leftmargin+position(3)+hspace top-topmargin-edsize(2) objsize('edit',5)];
	BangEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'Style','edit',...
						'Units','points',...
						'String',num2str(ArrowDefs(3)),...
						'Position',position,...
						'Callback','arrowdlg(''DrawArrow'')',...
						'Tag','bang');
	position(2) = position(2) - position(4) - vspace;
	TangEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'Style','edit',...
						'String',num2str(ArrowDefs(4)),...
						'Units','points',...
						'Position',position,...
						'Callback','arrowdlg(''DrawArrow'')',...
						'Tag','tang');
	txtsize = textlen('Length:');
	position = [position(1)+position(3)+hspace top-topmargin-edsize(2) txtsize(1) edsize(2)];
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'Style','text',...
						'String','Length:',...
						'Units','points',...
						'Position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'Style','text',...
						'String','Width:',...
						'Units','points',...
						'Position',position);
	position = [position(1)+position(3)+hspace top-topmargin-edsize(2) txtsize(1) edsize(2)];
	LengthEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','edit',...
						'Units','points',...
						'String',num2str(ArrowDefs(1)),...
						'Position',position,...
						'Callback','arrowdlg(''DrawArrow'')',...
						'Tag','length');
	position(2) = position(2) - position(4) - vspace;
	WidthEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','edit',...
						'String',num2str(ArrowDefs(2)),...
						'Units','points',...
						'Position',position,...
						'Callback','arrowdlg(''DrawArrow'')',...
						'Tag','width');

	txtsize = textlen('Blah Blah');
	position = [position(1)+position(3)+2*hspace top-topmargin textlen('Arrow Plane:') edsize(2)];
	uicontrol(titlefig,'Style','Text',...
			  'ForegroundColor',ForegroundColor,...
			  'BackgroundColor',BackgroundColor,...
			  'String','Arrow Plane:',...
			  'Units','points',...
			  'Position',position);
	position = [position(1) top-topmargin-edsize(2) txtsize(1) edsize(2)];
	uicontrol(titlefig,'Style','radio',...
			  'ForegroundColor',ForegroundColor,...
			  'BackgroundColor',BackgroundColor,...
			  'Value',1,...
			  'String','Auto',...
			  'Units','points',...
			  'Callback','arrowdlg(''Radio'')',...
			  'Position',position);
	position(2) = position(2) - position(4) - vspace;
	tpos = position;
	uicontrol(titlefig,'Style','radio',...
			  'ForegroundColor',ForegroundColor,...
			  'BackgroundColor',BackgroundColor,...
			  'String',' XY ',...
			  'Units','points',...
			  'Callback','arrowdlg(''Radio'')',...
			  'Position',position);
	position = [position(1)+position(3)+hspace top-topmargin-edsize(2) txtsize(1) edsize(2)];
	uicontrol(titlefig,'Style','radio',...
			  'ForegroundColor',ForegroundColor,...
			  'BackgroundColor',BackgroundColor,...
			  'String',' YZ ',...
			  'Units','points',...
			  'Callback','arrowdlg(''Radio'')',...
			  'Position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'Style','radio',...
			  'ForegroundColor',ForegroundColor,...
			  'BackgroundColor',BackgroundColor,...
			  'String',' XZ ',...
			  'Units','points',...
			  'Callback','arrowdlg(''Radio'')',...
			  'Position',position);
	if(position(1)+position(3) > figpos(3))
		figpos(3) = position(1)+position(3)+10;
		set(titlefig,'Position',figpos);
	end
	position = [tpos(1) tpos(2)-edsize(2)-2*vspace 80 edsize(2)+5];
	uicontrol(titlefig,'Style','pushbutton',...
			  'ForegroundColor',Widgetfground,...
			  'BackgroundColor',Widgetbground,...
			  'String','Apply',...
			  'Units','points',...
			  'Callback','arrowdlg(''Apply'')',...
			  'Position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'Style','pushbutton',...
			  'ForegroundColor',Widgetfground,...
			  'BackgroundColor',Widgetbground,...
			  'String','Cancel',...
			  'Units','points',...
			  'Callback','arrowdlg(''Cancel'')',...
			  'Position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'Style','pushbutton',...
			  'ForegroundColor',Widgetfground,...
			  'BackgroundColor',Widgetbground,...
			  'String','OK',...
			  'Units','points',...
			  'Callback','arrowdlg(''OK'')',...
			  'Position',position);
    axes('Units','Points',...
	     'Position', [20 20 200 100],...
		 'Xlim',[0 1],'Ylim',[0 1],...
		 'XTickLabelMode','manual',...
		 'XTickLabel',[],...
		 'YTickLabelMode','manual',...
		 'YTickLabel',[],...
		 'XColor',BackgroundColor,...
		 'YColor',BackgroundColor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If there's only one arrow selected, %
% then set initial values of widgets  %
% to match its properties.            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	SelectList = MDDatObjs.SelectList;
	if(size(SelectList,1) == 1)
		if(strcmp(get(SelectList(1),'Tag'),'Arrow'))
			ArrData = get(SelectList(1),'UserData');
			if(length(ArrData == 15)) % Double Check
				set(findobj(gcf,'tag','length'),'String',num2str(ArrData(7)));
				set(findobj(gcf,'tag','bang'),'String',num2str(ArrData(8)));
				set(findobj(gcf,'tag','tang'),'String',num2str(ArrData(9)));
				set(findobj(gcf,'tag','width'),'String',num2str(ArrData(10)));
			end
		end
	end
	
%%%%%%%%%%%%%%%%%%%%%
% Draw Sample Arrow %
%%%%%%%%%%%%%%%%%%%%%

	set(gcf,'UserData',arrow('start',[.2 .5],'stop',[.8 .5],...
							 'BaseAngle',str2num(get(findobj(gcf,'tag','bang'),'string')),...
							 'TipAngle',str2num(get(findobj(gcf,'tag','tang'),'string')),...
							 'Length',str2num(get(findobj(gcf,'tag','length'),'string')),...
							 'Width',str2num(get(findobj(gcf,'tag','width'),'string'))));
elseif(strcmp(command,'DrawArrow'))
	arrow_handle = get(gcf,'UserData');
	arrow(arrow_handle,...
		  'start',[.2 .5],...
		  'stop',[.8 .5],...
		  'BaseAngle',str2num(get(findobj(gcf,'tag','bang'),'string')),...
		  'TipAngle',str2num(get(findobj(gcf,'tag','tang'),'string')),...
		  'Length',str2num(get(findobj(gcf,'tag','length'),'string')),...
		  'Width',str2num(get(findobj(gcf,'tag','width'),'string')));
elseif(strcmp(command,'Radio'))
	ThisButton = gco;
	OtherButtons = findobj(gcf,'Style','radiobutton');
	OtherButtons = OtherButtons(find(OtherButtons ~= ThisButton));
	set(ThisButton,'Value',1);
	set(OtherButtons,'Value',0);
elseif(strcmp(command,'Cancel'))
	delete(gcf);
elseif(strcmp(command,'Apply'))
	global MDDatObjs;
	SelectList = MDDatObjs.SelectList;
	BaseAngle = str2num(get(findobj(gcf,'Tag','bang'),'String'));
	TipAngle = str2num(get(findobj(gcf,'Tag','tang'),'String'));
	Length = str2num(get(findobj(gcf,'Tag','length'),'String'));
	Width = str2num(get(findobj(gcf,'Tag','width'),'String'));
	NormString = get(findobj(gcf,'Style','radiobutton','Value',1),'String');
	if(strcmp(NormString,' XY '))
		NormDir = [0 0 1];
	elseif(strcmp(NormString,' XZ '))
		NormDir = [0 1 0];
	elseif(strcmp(NormString,' YZ '))
		NormDir = [1 0 0];
	else 
		NormDir = [NaN NaN NaN];
	end
	if(~isempty(SelectList))
		Arrows = findobj(SelectList(:,1),'Tag','Arrow');
		if(~isempty(Arrows))
			arrow(Arrows,'BaseAngle',BaseAngle,...
							 'TipAngle',TipAngle,...
							 'Length',Length,...
							 'Width',Width,...
							 'Norm',NormDir);
		else
			MDDatObjs.Defaults.Arrow(1:7) = [Length Width BaseAngle TipAngle NormDir];
		end
	else
		MDDatObjs.Defaults.Arrow(1:7) = [Length Width BaseAngle TipAngle NormDir];
	end
elseif(strcmp(command,'OK'))
	arrowdlg('Apply');
	delete(gcf);
end
function len = textlen(string,units)
if(nargin<2)
	units = 'points';
end
len = zeros(size(string,1),1);
h = text('Position',[0 0],...
			'Visible','off',...
			'Units',units,...
			'FontName','Helvetica',...
			'FontSize',12);
for(i=1:size(string,1))
	set(h,'String',deblank(string(i,:)));
	extent = get(h,'Extent');
	len(i) = extent(3)+1;
end
delete(h);
function ext = objsize(ObjType,NumChars,NumLines)
if(nargin < 3)
	NumLines = 1;
end
ext = zeros(1,2);
if(strcmp(computer,'MAC2') | strcmp(computer,'SUN4'))
	if(strcmp(ObjType,'uitext'))
		ext(1) = 10*NumChars+7;
		ext(2) = 13*NumLines - 1;
	elseif(strcmp(ObjType,'edit'))
		ext(1) = 10*NumChars+1;
		ext(2) = 14*NumLines + 4;
	elseif(strcmp(ObjType,'pushbutton'))
		ext(1) = 10*NumChars+6;
		ext(2) = 18;
	elseif(strcmp(ObjType,'popupmenu'))
		ext(1) = 10*NumChars+36;
		ext(2) = 18;
	elseif(strcmp(ObjType,'checkbox') | strcmp(ObjType,'radio'))
		ext(1) = 10*NumChars+17;
		ext(2) = 12;
	end
else
	if(strcmp(ObjType,'uitext'))
		ext(1) = 5*NumChars+3;
		ext(2) = 12*NumLines+2;
	elseif(strcmp(ObjType,'edit'))
		ext(1) = 5*NumChars+4;
		ext(2) = 12*NumLines + 2;
	elseif(strcmp(ObjType,'pushbutton'))
		ext(1) = 6*NumChars+1;
		ext(2) = 14;
	elseif(strcmp(ObjType,'popupmenu'))
		ext(1) = 6*NumChars+18;
		ext(2) = 14;
	elseif(strcmp(ObjType,'checkbox') | strcmp(ObjType,'radio'))
		ext(1) = 6*NumChars+16;
		ext(2) = 14;
	end
end
