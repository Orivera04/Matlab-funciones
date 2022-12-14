function viewer(command)

if(nargin < 1)
	command = 'SETUP';
end
switch(command),
	case 'SETUP',
		fig = gcf;
		ax = gca;
		setup;
		setfigure(fig);
		set(gcf,'UserData',ax);
		vw = get(ax,'view');
		if(vw(1) > 180)
			vw(1) = vw(1)-360;
		end
		set(findobj(gcf,'Tag','SLIDER_AZ'),'Value',vw(1));
		set(findobj(gcf,'Tag','SLIDER_EL'),'Value',vw(2));
		set(findobj(gcf,'Tag','SLIDER_ZOOM'),'Value',0);
		set(findobj(gcf,'Tag','EDIT_AZ'),'String',num2str(vw(1)));
		set(findobj(gcf,'Tag','EDIT_EL'),'String',num2str(vw(2)));
		set(findobj(gcf,'Tag','EDIT_ZOOM'),'String','0');
		set(gca,'HandleVisibility','Callback');
		axes(findobj(gcf,'Tag','AXES_VIEW'));
		line('xdata',[0 .8],'ydata',[0 0],'zdata',[0 0],'linewidth',3);
		text(.9,0,0,'X');
		line('xdata',[0 0],'ydata',[0 .8],'zdata',[0 0],'linewidth',3);
		text(0,.9,0,'Y');
		line('xdata',[0 0],'ydata',[0 0],'zdata',[0 .8],'linewidth',3);
		text(0,0,.9,'Z');
		axis([-.2 1.2 -.2 1.2 -.2 1.2]); grid;
		set(gca,'view',vw);
		set(gca,'XTick',[],'YTick',[],'ZTick',[],...
				'Box','on','HandleVisibility','callback');
		set(gcf,'handlevisibility','callback');
	case '>',
		figlist = get(0,'children');
		figlist = figlist(find(figlist~=gcf));
		ind = find(get(findobj(gcf,'Tag','CURRENTFIGURE'),'UserData')==figlist);
		if(isempty(ind) | ind == length(figlist))
			ind = 1;
		else 
			ind = ind+1;
		end
		setfigure(figlist(ind));
	case '<',
		figlist = get(0,'children');
		figlist = figlist(find(figlist~=gcf));
		ind = find(get(findobj(gcf,'Tag','CURRENTFIGURE'),'UserData')==figlist);
		if(isempty(ind) | ind == 1)
			ind = length(figlist);
		else 
			ind = ind-1;
		end
		setfigure(figlist(ind));
	case 'SLIDER_EL',
		if(get(findobj(gcf,'Tag','LOCK'),'Value') == 1)
		else
			set(findobj(gcf,'Tag','AXES_VIEW'),'View',...
				[get(findobj(gcf,'Tag','SLIDER_AZ'),'Value') ...
				 get(gcbo,'Value')]);
		end
		set(findobj(gcf,'Tag','EDIT_EL'),'String',num2str(get(gcbo,'Value')));	
	case 'SLIDER_AZ',
		if(get(findobj(gcf,'Tag','LOCK'),'Value') == 1)
		else
			set(findobj(gcf,'Tag','AXES_VIEW'),'View',...
				[get(gcbo,'Value') ...
				 get(findobj(gcf,'Tag','SLIDER_EL'),'Value')]);
		end
		set(findobj(gcf,'Tag','EDIT_AZ'),'String',num2str(get(gcbo,'Value')));
	case 'SLIDER_ZOOM',
		set(findobj(gcf,'Tag','EDIT_ZOOM'),'String',num2str(get(gcbo,'Value')));
		ax = findobj(gcf,'Tag','AXES_VIEW');
		set(ax,'CameraPosition',get(ax,'CameraTarget')+...
								get(findobj(gcf,'Tag','LOCK'),'UserData')...
								*2^(get(gcbo,'Value')));
	case 'UPDATE',
		ax = get(gcf,'UserData');
		viewer_ax = findobj(gcf,'Tag','AXES_VIEW');
		if(get(findobj(gcf,'Tag','LOCK'),'Value')==1)
			axlims = [get(ax,'xlim');get(ax,'ylim');get(ax,'zlim')]';
			cpos = get(viewer_ax,'CameraPosition');
			cpos = cpos.*diff(axlims);
			set(ax,'CameraPosition',cpos);
			set(ax,'CameraViewAngle',get(viewer_ax,'CameraViewAngle'));
		else
			set(ax,'View',get(viewer_ax,'View'));
		end
	case 'TARGET',
	case 'LOCK',
		if(get(gcbo,'Value')==1)
			set(findobj(gcf,'UserData','ZoomGroup'),'Enable','on');
			ax = findobj(gcf,'Tag','AXES_VIEW');
			set(ax,'CameraViewAngleMode','manual',...
				   'CameraPositionMode','manual');
			set(gcbo,'UserData',get(ax,'CameraPosition')-get(ax,'CameraTarget'));
		else
			set(findobj(gcf,'UserData','ZoomGroup'),'Enable','off');
			set(findobj(gcf,'Tag','AXES_VIEW'),...
			    'CameraViewAngleMode','auto',...
				'CameraPositionMode','auto');
		end
	case 'EDIT_EL',
		set(findobj(gcf,'Tag','AXES_VIEW'),'View',...
			[str2num(get(findobj(gcf,'Tag','EDIT_AZ'),'String')) ...
			 str2num(get(gcbo,'String'))]);
		set(findobj(gcf,'Tag','SLIDER_EL'),'Value',str2num(get(gcbo,'String')));
	case 'EDIT_AZ',
		set(findobj(gcf,'Tag','AXES_VIEW'),'View',...
			[str2num(get(gcbo,'String')) ...
			 str2num(get(findobj(gcf,'Tag','EDIT_EL'),'String'))]);
		set(findobj(gcf,'Tag','SLIDER_AZ'),'Value',str2num(get(gcbo,'String')));
	case 'EDIT_ZOOM',
		ax = findobj(gcf,'Tag','AXES_VIEW');
		set(ax,'CameraPosition',get(ax,'CameraTarget')+...
								get(findobj(gcf,'Tag','LOCK'),'UserData')...
								*2^(get(gcbo,'Value')));
		set(findobj(gcf,'Tag','SLIDER_ZOOM'),'Value',str2num(get(gcbo,'String')));
	case 'PROJECTION',
		if(get(gcbo,'Value')==1)
			set(findobj(gcf,'Tag','AXES_VIEW'),'Projection','Perspective');
		else
			set(findobj(gcf,'Tag','AXES_VIEW'),'Projection','Orthographic');
		end
	case 'PATCHBUTTONDOWN',
	
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
		% Update Patches in AXES_SUBPLOT %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

		AxTable = get(get(gcbo,'Parent'),'UserData');
		
		if(~all(ishandle(AxTable(:,1))))
			setfigure(get(findobj(gcf,'Tag','CURRENTFIGURE'),'UserData'));
			AxTable = get(findobj(gcf,'Tag','AXES_SUBPLOTS'),'UserData');
		else
			set(AxTable(:,2),'EdgeColor',[.8 .8 .8]);
			ind = find(AxTable(:,2) == gcbo);
			set(AxTable(ind,2),'EdgeColor','k');
		end
		ax = AxTable(ind,1);
		set(gcf,'UserData',ax);
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
		% Adjust AXES_VIEW to match current Axes %		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

		vw = get(ax,'view');
		if(vw(1) > 180)
			vw(1) = vw(1)-360;
		end
		set(findobj(gcf,'Tag','SLIDER_AZ'),'Value',vw(1));
		set(findobj(gcf,'Tag','SLIDER_EL'),'Value',vw(2));
		set(findobj(gcf,'Tag','SLIDER_ZOOM'),'Value',0);
		set(findobj(gcf,'Tag','EDIT_AZ'),'String',num2str(vw(1)));
		set(findobj(gcf,'Tag','EDIT_EL'),'String',num2str(vw(2)));
		set(findobj(gcf,'Tag','AXES_VIEW'),'View',vw);
		set(findobj(gcf,'Tag','EDIT_ZOOM'),'String','0');

end

function val = getset(object,getprop,setprop,setval);
%function val = getset(object,getprop,setprop,setval);
%Set a property, get another property, and then
%restore the original value to the first property.
oldval = get(object,setprop);
set(object,setprop,setval);
val = get(object,getprop);
set(object,setprop,oldval);

function [xdata,ydata] = rect2xy(extent)
xdata = [extent(1) extent(1)+extent(3) extent(1)+extent(3) extent(1)];
ydata = [extent(2) extent(2) extent(2)+extent(4) extent(2)+extent(4)];

function setfigure(fig)
	figtitle = get(fig,'name');
	if(isempty(figtitle))
		figtitle = ['Figure ' num2str(fig)];
	elseif(strcmp(get(fig,'NumberTitle'),'on'))
		figtitle = ['Figure ' num2str(fig) ': ' figtitle];
	end
	set(findobj(gcf,'Tag','CURRENTFIGURE'),'String',figtitle,...
		'UserData',fig);
	axlist = findobj(fig,'type','axes');
	AxTable = [];
	axes(findobj(gcf,'Tag','AXES_SUBPLOTS'));
	cla;
	axis([0 1 0 1]);
	for(axx = axlist')
		[xdata,ydata] = rect2xy(getset(axx,'Position','Units','Normalized'));
		AxTable = [AxTable; axx patch('XData',xdata,...
			  						 'YData',ydata,...
			 						 'FaceColor',[.8 .8 .8],...
			 						 'EdgeColor',[.8 .8 .8],...
									 'ButtonDownFcn','viewer(''PATCHBUTTONDOWN'')',...
			 						 'LineWidth',2)];
	end
	set(gca,'UserData',AxTable);
	set(AxTable(find(AxTable(:,1)==get(fig,'CurrentAxes')),2),'EdgeColor','k');

function setup()
% This is the machine-generated representation of a MATLAB object
% and its children.  Note that handle values may change when these
% objects are re-created. This may cause problems with some callbacks.
% The command syntax may be supported in the future, but is currently 
% incomplete and subject to change.
%
% To re-open this system, just type the name of the m-file at the MATLAB
% prompt. The M-file and its associtated MAT-file must be on your path.


a = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'KeyPressFcn','viewer(''keypress'')', ...
	'MenuBar','none', ...
	'Name','3D Viewer', ...
	'NumberTitle','off', ...
	'Position',[0 126 429 126], ...
	'Resize','off', ...
	'Tag','VIEWER');
set(gcf,'defaultuicontrolfontname','times')
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''<'')', ...
	'Position',[14 105 23 20], ...
	'String','<', ...
	'Tag','PBPrevious');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''>'')', ...
	'Position',[196 105 23 20], ...
	'String','>', ...
	'Tag','PBNext');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Position',[44 105 144 18], ...
	'Style','text', ...
	'FontWeight','Bold',...
	'FontSize',12,...
	'Tag','CURRENTFIGURE');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''SLIDER_EL'')', ...
	'Position',[38 74 150 20], ...
	'Style','slider', ...
	'SliderStep',[1/180 1/18],...
	'Max',90,'Min',-90,...
	'Tag','SLIDER_EL');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''SLIDER_AZ'')', ...
	'Position',[38 53 150 20], ...
	'SliderStep',[1/360 1/36],...
	'Max',180,'Min',-180,...
	'Style','slider', ...
	'Tag','SLIDER_AZ');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''SLIDER_ZOOM'')', ...
	'Position',[38 32 150 20], ...
	'Max',10,'Min',-10,...
	'SliderStep',[.01 .1],...
	'Enable','off',...
	'Style','slider', ...
	'UserData','ZoomGroup',...
	'Tag','SLIDER_ZOOM');
b = axes('Parent',a, ...
	'Units','points', ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'FontName','times', ...
	'Position',[236 15 110 110], ...
	'Tag','AXES_VIEW', ...
	'XColor',[0 0 0], ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Position',[0.5 -0.0412844 0], ...
	'Tag','Text1', ...
	'VerticalAlignment','cap');
set(get(c,'Parent'),'XLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.0412844 0.5 0], ...
	'Rotation',90, ...
	'Tag','Text2', ...
	'VerticalAlignment','baseline');
set(get(c,'Parent'),'YLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','right', ...
	'Position',[-2.16972 1.65596 0], ...
	'Tag','Text3', ...
	'Visible','off');
set(get(c,'Parent'),'ZLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Position',[0.5 1.06881 0], ...
	'Tag','Text4', ...
	'VerticalAlignment','bottom');
set(get(c,'Parent'),'Title',c);
b = axes('Parent',a, ...
	'Units','points', ...
	'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'FontName','times', ...
	'Position',[355 15 65 55], ...
	'Tag','AXES_SUBPLOTS', ...
	'XColor',[0 0 0], ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
c = text('Parent',b, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.492188 -0.0833333 0], ...
	'Tag','Text1', ...
	'VerticalAlignment','cap');
set(get(c,'Parent'),'XLabel',c);
c = text('Parent',b, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.0703125 0.509259 0], ...
	'Rotation',90, ...
	'Tag','Text2', ...
	'VerticalAlignment','baseline');
set(get(c,'Parent'),'YLabel',c);
c = text('Parent',b, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-5.55469 3.34259 0], ...
	'Tag','Text3', ...
	'Visible','off');
set(get(c,'Parent'),'ZLabel',c);
c = text('Parent',b, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'FontName','times', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.492188 1.13889 0], ...
	'Tag','Text4', ...
	'VerticalAlignment','bottom');
set(get(c,'Parent'),'Title',c);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''UPDATE'')', ...
	'Position',[354 105 60 20], ...
	'String','Update', ...
	'Tag','UPDATE');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.701961 0.701961 0.701961], ...
	'CallBack','viewer(''TARGET'')', ...
	'Position',[354 75 60 20], ...
	'String','Target', ...
	'Tag','TARGET');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'CallBack','viewer(''EDIT_EL'')', ...
	'Position',[188 75 44 20], ...
	'String','-180', ...
	'Style','edit', ...
	'FontName','Times',...
	'FontSize',9,...
	'Tag','EDIT_EL');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'CallBack','viewer(''EDIT_AZ'')', ...
	'Position',[188 54 44 20], ...
	'String','-180', ...
	'FontName','Times',...
	'FontSize',9,...
	'Style','edit', ...
	'Tag','EDIT_AZ');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'CallBack','viewer(''EDIT_ZOOM'')', ...
	'Position',[188 32 44 20], ...
	'FontName','Times',...
	'FontSize',9,...
	'String','-180', ...
	'Enable','off',...
	'UserData','ZoomGroup',...
	'Style','edit', ...
	'Tag','EDIT_ZOOM');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Position',[8 77 20 15], ...
	'String','EL', ...
	'Style','text', ...
	'Tag','EL');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Position',[8 55 20 15], ...
	'String','AZ', ...
	'Style','text', ...
	'Tag','AZ');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Position',[2 35 35 15], ...
	'String','Zoom', ...
	'Enable','off',...
	'UserData','ZoomGroup',...
	'Style','text', ...
	'Tag','Zoom');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'CallBack','viewer(''PROJECTION'')', ...
	'Max',2, ...
	'Min',1, ...
	'Position',[140 8 90 20], ...
	'FontName','Times',...
	'FontSize',9,...
	'String',['Perspective ';'Orthographic'], ...
	'Style','popupmenu', ...
	'Tag','POPUP_PROJECTION', ...
	'Value',1);
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Position',[80 8 60 17], ...
	'String','Projection', ...
	'Style','text', ...
	'Tag','Projection');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[0.8 0.8 0.8], ...
	'Position',[5 10 70 17], ...
	'String','Zoom Lock', ...
	'Style','Checkbox', ...
	'Value',0,...
	'HorizontalAlignment','Left',...
	'Callback','viewer(''LOCK'')',...
	'Tag','LOCK');
