function figcback(command)

% FIGCBACK Callback for MatDraw Figure Menu
% Function figcback(command)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  2/95

% Mods:

% Copyright (c) 1995 by Keith Rogers

if(command == 0)
	submenu = get(gcbo,'UserData');
	if(~isempty(submenu))
		if(strcmp(get(gcf,'MenuBar'),'figure'))
			set(submenu,'Label','Short Menus',...
						'Callback','figcback(2)');	
		else
			set(submenu,'Label','Full Menus',...
						'Callback','figcback(1)');
		end
	end
elseif(command == 1)
	fig = gcf;
	set(fig,'MenuBar','figure');
	if(strcmp(computer,'MAC2')) % Work around bug in Mac Matlab v4.2c
		EditMenu = findobj(fig,'Label','MDEdit');
		workspace = findobj(fig,'Label','Workspace');
		set(findobj(fig,'Label','Quit'),'Separator','off');
		delete(findobj(fig,'parent',EditMenu));
		delete(findobj(fig,'parent',workspace));
		uimenu(EditMenu,'Label','Undo','Callback','edtcback(1)');
		uimenu(EditMenu,'Label','Cut','Callback','edtcback(2)');
		uimenu(EditMenu,'Label','Copy','Callback','edtcback(3)');
		uimenu(EditMenu,'Label','Paste','Callback','edtcback(4)');
		uimenu(workspace,'Label','New Figure', 'Callback','wrkcback');
		uimenu(workspace,'Label','Load', 'Callback','wrkcback');
		uimenu(workspace,'Label','Save Workspace', 'Callback','wrkcback');
		uimenu(workspace,'Label','Save Figure', 'Callback','wrkcback');
		uimenu(workspace,'Label','Save As', 'Callback','wrkcback');
		uimenu(workspace,'Label','Add to Path', 'Callback','wrkcback');
		uimenu(workspace,'Label','Print','Callback','print');
		uimenu(workspace,'Label','Preferences','Callback','mddefs');
		uimenu(workspace,'Label','Quit MatDraw', 'Callback','wrkcback','Separator','on');
	else
		set(findobj(findobj(fig,'Label','MDEdit')),'Accelerator','');
		set(findobj(findobj(fig,'Label','Workspace')),'Accelerator','');
		set(findobj(fig,'Label','Zoom Out'),'Accelerator','');
	end
elseif(command == 2)
	fig = gcf;
	set(fig,'MenuBar','none');
	set(findobj(fig,'Label','Zoom Out'),'Accelerator','O');
	set(findobj(fig,'Label','New Figure'),'Accelerator','N');
	set(findobj(fig,'Label','Save Workspace'),'Accelerator','S');
	set(findobj(fig,'Label','Save As'),'Accelerator','A');
	set(findobj(fig,'Label','Print'),'Accelerator','P');
	set(findobj(fig,'Label','Quit MatDraw'),'Accelerator','Q');
	set(findobj(fig,'Label','Undo'),'Accelerator','Z');
	set(findobj(fig,'Label','Cut'),'Accelerator','X');
	set(findobj(fig,'Label','Copy'),'Accelerator','C');
	set(findobj(fig,'Label','Paste'),'Accelerator','V');
elseif(command == 3)
	pos = getset(gcf,'Position','Units','Points');
	uly = pos(2) + pos(4);
	ulx = pos(1);
	units = get(gcf,'PaperUnits');
	set(gcf,'PaperUnits','points');
	paperpos = get(gcf,'PaperPosition');
	set(gcf,'PaperUnits',units);
	units = get(gcf,'Units');
	set(gcf,'Units','Points');
	set(gcf,'Position',[ulx uly-paperpos(4) paperpos(3:4)]);
	set(gcf,'Units',units);
elseif(command == 4)
	Allfigs  = get(0,'Children');
	figure(Allfigs(length(Allfigs)));
elseif(command == 5)
	Allfigs  = get(0,'Children');
	figure(Allfigs(2));
end
