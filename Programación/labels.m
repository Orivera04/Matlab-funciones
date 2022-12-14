function labels(command)
%LABELS  Create a dialog box for modifying titles and labels
%Labels creates a dialog box with edit uicontrols for modifying 
%axes' titles, xlabels, ylabels, and zlabels. To the right
%of these fields the axes present in the current figure
%are shown as blue patches, with the active axes shown with
%a white border.  The active axes may be changed simply by
%clicking on another of the blue patches.  At start and when
%axes are changed, the appropriate data for each field for
%the active axes will be loaded.  If an axes has no data for
%a particular field, the text in that field will remain unchanged.
%
%Thus if we set the Y label in one subplot to "Magnitude (db)" and
%then switch axes, to a subplot with no Y label, the Y label field
%will still contain the text "Magnitude (db)".  
%
%There are three buttons at the bottom of the dialog box, "OK",
%"Cancel", and "Apply".  Pressing "OK" sets the labels of the
%active axes to the values contained in the edit uicontrols and
%closes the dialog box.  "Cancel" simply closes the dialog box
%without modifying any labels.  "Apply" sets the labels of
%the active axes to the values in the edit uicontrols but does
%*not* close the dialog box.
%
%When the focus is held by the edit uicontrols, the tab key
%will switch between fields.  When it is not, hitting the
%return key is equivalent to pressing the OK button, hitting
%the escape key is equivalent to pressing the Cancel button,
%and hitting the "a" key is equivalent to pressing the Apply
%button.
%
%Keith Rogers 1/4/95

% Copyright (c) 1995 by Keith Rogers

if(nargin<1)
	BackgroundColor = .8*ones(1,3);
	ForegroundColor = 'k';
	Widgetbground = .7*ones(1,3);
	Widgetfground = 'k';
	PatchColor = 'k';
    tit = get(gca,'title');
	fig = gcf;
	kids = get(fig,'Children');
	ax = gca;
	figpos = [150 250 380 200];
	titlefig = figure('Color',BackgroundColor,...
					  'Units','Points',...
	                  'Position',figpos,...
					  'Name','Labels',...
					  'Resize','off',...
					  'NumberTitle','off',...
					  'UserData',fig,...
					  'KeyPressFcn','labels(5)');
	set(gca,'Visible','off');
	top = figpos(4);
	right = figpos(3);
	leftmargin = 10;
	topmargin = 30;
	vspace = 10;
	hspace = 5;
	edsize = objsize('edit',20);
	txtsize = textlen('Xlabel');
	pgtitlelen = textlen('Page Title:');
	position = [(figpos(3)-hspace-edsize(1)-pgtitlelen)/2 top-5-edsize(2) textlen('Page Title:') edsize(2)];
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'style','text',...
						'string','Page Title:',...
						'units','points',...
						'position',position);
	position(1) = position(1)+position(3)+hspace;
	position(3) = edsize(1);
	PageTitleEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
					   'ForegroundColor',Widgetfground,...
					   'style','edit',...
					   'units','points',...
					   'string','',...
					   'position',position,...
					   'tag','pagetitle');
	StreamerObj = findobj(fig,'Tag','Streamer');
	if(StreamerObj)
		set(PageTitleEdit,'String',get(get(StreamerObj,'Title'),'String'));
	end
	
	position = [leftmargin top-topmargin-edsize(2) txtsize edsize(2)];
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'style','text',...
						'string','Title:',...
						'units','points',...
						'position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'style','text',...
						'string','Xlabel:',...
						'units','points',...
						'position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'style','text',...
						'string','Ylabel:',...
						'units','points',...
						'position',position);
	position(2) = position(2) - position(4) - vspace;
	uicontrol(titlefig,'BackgroundColor',BackgroundColor,...
						'ForegroundColor',ForegroundColor,...
						'style','text',...
						'string','Zlabel:',...
						'units','points',...
						'position',position);
	position = [leftmargin+position(3)+hspace top-topmargin-edsize(2) objsize('edit',20)];
	TitleEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','edit',...
						'units','points',...
						'string',get(get(ax,'title'),'string'),...
						'position',position,...
						'tag','title');
	position(2) = position(2) - position(4) - vspace;
	XlabelEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
                        'style','edit',...
						'string',get(get(ax,'xlabel'),'string'),...
						'units','points',...
						'position',position,...
						'tag','xlabel');
	position(2) = position(2) - position(4) - vspace;
	YlabelEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','edit',...
						'string',get(get(ax,'ylabel'),'string'),...
						'units','points',...
						'position',position,...
						'tag','ylabel');
	position(2) = position(2) - position(4) - vspace;
	ZlabelEdit = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','edit',...
						'string',get(get(ax,'zlabel'),'string'),...
						'units','points',...
						'position',position,...
						'tag','zlabel');
	position(1) = position(1) + hspace + edsize(1);
	position(3) = right-position(1) - hspace;
	position(4) = top - topmargin - position(2);
	axobj = axes('Color',BackgroundColor,...
	             'Units','points',...
				 'Position',position,...
				 'XTickLabelMode','manual',...
				 'XTickLabel',[],...
				 'YTickLabelMode','manual',...
				 'YTickLabel',[],...
				 'XColor',BackgroundColor,...
				 'YColor',BackgroundColor);
				 
	patches = zeros(1,length(kids));
	for(i=1:length(kids))
		if(strcmp(get(kids(i),'type'),'axes') & ...
		   ~strcmp(get(kids(i),'Tag'),'Streamer'))
			pos = get(kids(i),'Position');
			patches(i) = patch('XData',[pos(1) pos(1)+pos(3) pos(1)+pos(3) pos(1)],...
							   'YData',[pos(2) pos(2) pos(2)+pos(4) pos(2)+pos(4)],...
							   'FaceColor',PatchColor,...
							   'UserData',kids(i),...
							   'ButtonDownFcn','labels(1)',...
							   'Linewidth',2);
		end
	end
	cax = get(fig,'CurrentAxes');
	set(patches(find(kids==cax)),'EdgeColor','w');
	
	buttonsize = objsize('pushbutton',6);
	position(2) = position(2)-2*buttonsize(2)-vspace;
	position(4) = 2*buttonsize(2);
	OKbutton = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','pushbutton',...
						'string','OK',...
						'units','points',...
						'position',position,...
						'callback','labels(2)');	
	position(1) = position(1) - hspace - buttonsize(1);
	position(3) = buttonsize(1);
	Cancelbutton = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','pushbutton',...
						'string','Cancel',...
						'units','points',...
						'position',position,...
						'callback','labels(3)');	
	position(1) = position(1) - hspace - buttonsize(1);
	Applybutton = uicontrol(titlefig,'BackgroundColor',Widgetbground,...
						'ForegroundColor',Widgetfground,...
						'style','pushbutton',...
						'string','Apply',...
						'units','points',...
						'position',position,...
						'callback','labels(4)');	
elseif(command == 1)
	axobj = get(gco,'UserData');
	tit = get(get(axobj,'title'),'String');
	if(~isempty(tit))
		set(findobj(gcf,'Tag','title'),'String',tit);
	end
	xlab = get(get(axobj,'xlabel'),'String');
	if(~isempty(xlab))
		set(findobj(gcf,'Tag','xlabel'),'String',xlab);
	end
	ylab = get(get(axobj,'ylabel'),'String');
	if(~isempty(ylab))
		set(findobj(gcf,'Tag','ylabel'),'String',ylab);
	end
	zlab = get(get(axobj,'zlabel'),'String');
	if(~isempty(zlab))
		set(findobj(gcf,'Tag','zlabel'),'String',zlab);
	end
	set(findobj(gcf,'EdgeColor',[1 1 1]),'EdgeColor','b');
	set(gco,'EdgeColor','w');
elseif(command == 2)
	axobj = get(findobj(gcf,'EdgeColor',[1 1 1]),'UserData');
	set(get(axobj,'title'),'string',get(findobj(gcf,'Tag','title'),'string'));
	set(get(axobj,'xlabel'),'string',get(findobj(gcf,'Tag','xlabel'),'string'));
	set(get(axobj,'ylabel'),'string',get(findobj(gcf,'Tag','ylabel'),'string'));
	set(get(axobj,'zlabel'),'string',get(findobj(gcf,'Tag','zlabel'),'string'));
	delete(gcf);
elseif(command == 3)
	delete(gcf);
elseif(command == 4)
	fig = get(gcf,'UserData');
	PageTitle = get(findobj(gcf,'Tag','pagetitle'),'String');
	if(PageTitle)
		streamer(fig,PageTitle);
	end
	axobj = get(findobj(gcf,'EdgeColor',[1 1 1]),'UserData');
	set(get(axobj,'title'),'string',get(findobj(gcf,'Tag','title'),'string'));
	set(get(axobj,'xlabel'),'string',get(findobj(gcf,'Tag','xlabel'),'string'));
	set(get(axobj,'ylabel'),'string',get(findobj(gcf,'Tag','ylabel'),'string'));
	set(get(axobj,'zlabel'),'string',get(findobj(gcf,'Tag','zlabel'),'string'));
elseif(command == 5)
	if(get(gcf,'currentcharacter')-0==13)
		labels(2);
	elseif(get(gcf,'currentcharacter')-0==27)
		labels(3);
	elseif(get(gcf,'currentcharacter')-0=='a')
		labels(4);
	end
end


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
% 			'FontName','Geneva',...
% 			'FontSize',10);




