%  This callback routine has to be an m-file, not a function
%  because it modifies the workspace.  We know which function to
%  execute by examining the label of the current menu item.
%
% Keith Rogers 11/93
% Mods:
%     12/02/94  Shorten name to appease DOS users,
%               Change "makemenus" to "matdraw"

SavedFile = get(get(gcbo,'Parent'),'UserData');

if (strcmp(get(gcbo,'Label'),'Load'))
	[filename,pathname] = uigetfile('*.mat',...
	'Choose a MATLAB Data file',50,50);
	if (filename ~= 0)
		SavedFile = [pathname filename];
		clear filename pathname;
		eval(['load ' SavedFile ';']);
		set(get(gcbo,'Parent'),'UserData',SavedFile);
	end
elseif (strcmp(get(gcbo,'Label'),'Save'))
	if (strcmp(SavedFile,''))
		[filename,pathname] = uiputfile('*.mat','Data Filename',...
			50,50);
		if (filename)
			SavedFile = [pathname filename];
			clear filename pathname;
			eval(['save ' SavedFile ';']);
			set(get(gcbo,'Parent'),'UserData',SavedFile);
		end
	else
		eval(['save ' SavedFile ';']);
	end
elseif (strcmp(get(gcbo,'Label'),'Save As'))
	if (strcmp(SavedFile,''))
		[filename,pathname] = uiputfile('*.mat','Data Filename',...
			50,50);
	else
		[filename,pathname] = uiputfile(SavedFile,'Data Filename',...
			50,50);
	end
	if (filename)
		SavedFile = [pathname filename];
		clear filename pathname;
		eval(['save ' SavedFile ';']);
		set(get(gcbo,'Parent'),'UserData',SavedFile);
	end
elseif (strcmp(get(gcbo,'Label'),'Print'))
	global MDDatObjs;

	%%%%%%%%%%%%%%%%%%%%%%
	% Fix all the arrows %
	%%%%%%%%%%%%%%%%%%%%%%

	Arrows = findobj(gcf,'Tag','Arrows');
	if ~isempty(Arrows),
		page = get(Arrows,'UserData'); 
		page = cat(1,page{:}); 
		page = page(:,11); arrow(Arrows,'Page',1);
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get Filename, if necessary %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	SaveString = MDDatObjs.Defaults.SaveString;
	if(SaveString(2) == 'd' & SaveString(3) == 'e' | SaveString(3) == 'i' | ...
	   SaveString(3) == 'p' | SaveString(3) == 'g' & ...
	   ~strcmp(SaveString,'-depson') & ~strcmp(SaveString,'-deps9high')) 
		if(SaveString(3) == 'e')
			extension = '*.eps';
		elseif(SaveString(3) == 'i')
			extension = '*.ill';
		elseif(SaveString(3) == 'p')
			if(SaveString(4) == 'c')
				extension = '*.pcx';
			else
				extension = '*.ps';
			end
		elseif(SaveString(3) == 'g')
				extension = '*.gif';
		end
		[filename,pathname] = uiputfile(extension,'Filename',...
			50,50);
		if(filename)
			print(SaveString,[pathname filename]);
		end

		clear extension filename pathname;
	else
		print(SaveString);
	end

	%%%%%%%%%%%%%%%%%%%%%%
	% restore the arrows %
	%%%%%%%%%%%%%%%%%%%%%%

	if ~isempty(Arrows),
		arrow(Arrows,'Page',page); 
	end; 

	%%%%%%%%%%%%
	% Clean up %
	%%%%%%%%%%%%

	clear Arrows page SaveString MDDatObjs;

elseif (strcmp(get(gcbo,'Label'),'New Figure'))
	figure;
	matdraw;
elseif (strcmp(get(gcbo,'Label'),'Save Figure'))
	delete(findobj(gcf,'Type','uimenu','Parent',gcf));
	wbdfcn = get(gcf,'WindowButtonDownFcn');
	set(gcf,'ResizeFcn','','WindowButtonDownFcn','','KeypressFcn','');
	[fname,pname] = uiputfile('*.m','Save figure to m-file:');
	if(fname)
		print('-dmfile',[pname fname]);
	else
		disp('Save failed!');
	end
	mdprog(3);
	set(gcf,'WindowButtonDownFcn',wbdfcn);
elseif (strcmp(get(gcbo,'Label'),'Add to Path'))
    [MDpathfile,MDpathpath] = uigetfile('*','Select a file in the directory which you wish to add.');
    if(~isempty(MDpathfile))
		path(path,MDpathpath(1:length(MDpathpath)-1));
	end
	clear MDpathfile MDpathpath;
elseif (strcmp(get(gcbo,'Label'),'Quit MatDraw'))
	global MDDatObjs;
	fig = gcf;
	SelectList = MDDatObjs.SelectList;
	for(i=1:size(SelectList,1))
		if(ishandle(SelectList(i,1)))
			type = get(SelectList(i,1),'type');
			set(SelectList(i,1),'Selected','off');
			if(strcmp(type,'line'))
				set(SelectList(i,1),'Color',SelectList(i,2:4));
			elseif(strcmp(type,'patch'))
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
	if(find(MDDatObjs.FigList==fig))
		MDDatObjs.MenuList = MDDatObjs.MenuList(find(MDDatObjs.FigList~=fig),:);
		MDDatObjs.FigList = MDDatObjs.FigList(find(MDDatObjs.FigList~=fig));
	end
	if(isempty(MDDatObjs.FigList))
		delete(MDDatObjs.pfig);
		clear global MDDatObjs;
	else
		clear MDDatObjs;
	end
	delete(findobj(fig,'Type','uimenu','Parent',fig));
	set(fig,'ResizeFcn','',...
	        'WindowButtonDownFcn','',...
			'KeypressFcn','',...
			'Pointer','arrow',...
			'menubar','figure');
	clear fig;
end

