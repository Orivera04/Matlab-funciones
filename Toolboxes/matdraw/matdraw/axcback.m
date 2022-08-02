function axcback(command,ax)

% AXCBACK Callback for MatDraw Axis Menu
% Function axcback(command,ax)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  11/93

% Mods:
%    09/16/94  Added in labeling functions
%    12/01/94  Changed Toggling to update automatically
%    12/02/94  Shortened name to appease DOS Users
%    01/04/95  Magnification level changed by dialog box
%              instead of "input" now, labeling functions
%              taken out and put into "labels" m-file.
%	 02/28/95  Added in expand and reduce functions
% Copyright (c) 1995 by Keith Rogers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Commands
%
%  0:   Update submenus
%  1:	axis 'x'	X-Axis Lin/Log toggle	
%  2:	axis 'x'	X-Axis Auto Scale lower limit	
%  3:	axis 'x'	X-Axis Auto Scale upper limit	
%  4:	Toggle Hold On/Off
%  5:	Toggle Axis Limits Freeze/Auto
%  6:	axis 'x' 	Toggle Zoom Axis control 
%  7:	Adjust Magnification Level for zoom
%  8:	Expand subplot to full screen
%  9:	Reduce full screen back to subplot
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global MDDatObjs
if (command == 0)
	submenu = get(gcbo,'UserData');
	if(strcmp(get(gca,'xlimmode'),'manual'))
		set(submenu(1),'Label','Auto','Callback','axcback(5,0)');
	else
		set(submenu(1),'Label','Freeze','Callback','axcback(5,0)');
	end
	if(strcmp(get(gca,'Xscale'),'log'))
		set(submenu(2),'Label','Linear','Callback','axcback(1,''X'')');
	else
		set(submenu(2),'Label','Log','Callback','axcback(1,''X'')');
	end
	if(strcmp(get(gca,'Yscale'),'log'))
		set(submenu(3),'Label','Linear','Callback','axcback(1,''Y'')');
	else
		set(submenu(3),'Label','Log','Callback','axcback(1,''Y'')');
	end
	if(strcmp(get(gca,'Zscale'),'log'))
		set(submenu(4),'Label','Linear','Callback','axcback(1,''Z'')');
	else
		set(submenu(4),'Label','Log','Callback','axcback(1,''Z'')');
	end
	if(ishold)
		set(submenu(5),'Label','Hold off',...
							'Callback','axcback(4,0)',...
							'Accelerator','H');
	else
		set(submenu(5),'Label','Hold on',...
							'Callback','axcback(4,0)',...
							'Accelerator','H');
	end
elseif (command == 1)
	if (ax == 'X')
		if(strcmp(get(gcbo,'Label'),'Log'))
			set(gca,'Xscale','log');
		else
			set(gca,'Xscale','linear');
		end
		Arrows = findobj(gca,'Tag','Arrow');
		if(~isempty(Arrows))
			arrow(Arrows);
		end
	elseif (ax == 'Y')
		if(strcmp(get(gcbo,'Label'),'Log'))
			set(gca,'Yscale','log');
			set(gcbo,'Label','Linear');
		else
			set(gca,'Yscale','linear');
			set(gcbo,'Label','Log');
		end
		Arrows = findobj(gca,'Tag','Arrow');
		if(~isempty(Arrows))
			arrow(Arrows);
		end
	elseif (ax == 'Z')
		if(strcmp(get(gcbo,'Label'),'Log'))
			set(gca,'Zscale','log');
			set(gcbo,'Label','Linear');
		else
			set(gca,'Zscale','linear');
			set(gcbo,'Label','Log');
		end
		Arrows = findobj(gca,'Tag','Arrow');
		if(~isempty(Arrows))
			arrow(Arrows);
		end
	end
elseif (command == 2)
	if (ax == 'X')
		minmax = get(gca,'XLim');
		set(gca,'XLim',[-inf minmax(2)]);
	elseif (ax == 'Y')
		minmax = get(gca,'YLim');
		set(gca,'YLim',[-inf minmax(2)]);
	elseif (ax == 'Z')
		minmax = get(gca,'ZLim');
		set(gca,'ZLim',[-inf minmax(2)]);
	end
elseif (command == 3)
	if (ax == 'X')
		minmax = get(gca,'XLim');
		set(gca,'XLim',[minmax(1) inf]);
	elseif (ax == 'Y')
		minmax = get(gca,'YLim');
		set(gca,'YLim',[minmax(1) inf]);
	elseif (ax == 'Z')
		minmax = get(gca,'ZLim');
		set(gca,'ZLim',[minmax(1) inf]);
	end
elseif (command == 4)
	if (ishold)
		hold off;
		set(gcbo,'Label','Hold on');
	else
		hold on;
		set(gcbo,'Label','Hold off');
	end
elseif (command == 5)
	if(strcmp(get(gcbo,'Label'),'Freeze'))
		axis(axis);
		set(gcbo,'Label','Auto');
	else
		axis('auto');
		set(gcbo,'Label','Freeze');
	end
elseif (command == 6)
	if (ax == 'X')
		if (MDDatObjs.ZoomData.X)
			set(gcbo,'Checked','off');
			MDDatObjs.ZoomData.X = 0;
		else
			set(gcbo,'Checked','on');
			MDDatObjs.ZoomData.X = 1;
		end
	elseif (ax == 'Y')
		if (MDDatObjs.ZoomData.Y)
			set(gcbo,'checked','off');
			MDDatObjs.ZoomData.Y = 0;
		else
			set(gcbo,'Checked','on');
			MDDatObjs.ZoomData.Y = 1;
		end
	else
		if (MDDatObjs.ZoomData.Z)
			set(gcbo,'Checked','off');
			MDDatObjs.ZoomData.Z = 0;
		else
			set(gcbo,'Checked','on');
			MDDatObjs.ZoomData.Z = 1;
		end
	end
elseif (command == 7)
	maglevel = inputdlg('Magnification Level?','MatDraw',1,MDDatObjs.ZoomData.maglevel);
	if(isempty(maglevel))
		return;
	else
		maglevel = str2num(maglevel);
		if(isempty(maglevel))
			errordlg('Magnification level must be numeric!');
			return;
		else
			MDDatObjs.ZoomData.maglevel = maglevel;
		end
	end
	set(gcbo,'Label',['Mag Level -' num2str(MDDatObjs.ZoomData.maglevel) '-']);
elseif (command == 8)
	allax = findobj(gcf,'Type','axes','Visible','on');
	set(findobj(allax(find(allax~=gca))),'Visible','off','Tag','Restore');
	set(gcbo,'UserData',get(gca,'Position'),...
			  'Label','Reduce',...
			  'Callback','axcback(9)',...
			  'Accelerator','R');
	set(gca,'Position',get(gcf,'DefaultAxesPosition'));
elseif (command == 9)
	allax = findobj(gcf,'type','axes','Tag','Restore');
	set(gca,'Position',get(gcbo,'UserData'))
	set(findobj(allax),'Visible','on','Tag','');
	set(gcbo,'Label','Expand',...
			  'Callback','axcback(8)',...
			  'Accelerator','E');
end
