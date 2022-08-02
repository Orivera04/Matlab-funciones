function txtcback(command,data)
% Function txtcback(command,data)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  11/94
%
% Mods:
%    12/02/94  Shortened name to appease DOS Users
%    12/28/94  Allow Axes Font parameters to be changed

global MDDatObjs;
pfig = MDDatObjs.pfig;
selectList = MDDatObjs.SelectList;
UndoList = MDDatObjs.Undo;
if(isempty(selectList))
	Defaults = MDDatObjs.Defaults;
	menu = gcbo;
	Mom = get(menu,'Parent');
	if(command == 1)
		Defaults.FontName = data;
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',menu);		
	elseif(command == 2)
		Defaults.FontAngle = data;
		if(~isempty(get(Mom,'UserData')))
			set(get(Mom,'UserData'),'Checked','off');
		end
		set(Mom,'UserData',menu);		
	elseif(command == 3)
		Defaults.FontWeight = data;
		pmen = findobj(Mom,'Label','Plain');
		if(~isempty(pmen))
			set(get(pmen,'UserData'),'Checked','off');
		end
		if(get(Mom,'UserData')==pmen)
			set(pmen,'Checked','off')
			set(Mom,'UserData',[]);
		end
		set(pmen,'UserData',menu);		
	elseif(command == 4)
		Defaults.FontWeight = data;
		if(~isempty(get(Mom,'UserData')))
			set(get(Mom,'UserData'),'Checked','off');
		end
		if(~isempty(get(menu,'UserData')))
			set(get(menu,'UserData'),'Checked','off');
		end
		set(Mom,'UserData',menu);
		set(menu,'UserData',[]);		
	elseif(command == 5)
		if(data == 0)
			txtsize = inputdlg('Font Size?','MatDraw',1);
			if(isempty(txtsize))
				return;
			else
				txtsize = str2num(txtsize{1});
				if(isempty(txtsize))
					errordlg('Font size must be numeric!');
					return;
				end
			end
			Defaults.FontSize = txtsize;
		else			
			Defaults.FontSize = data;
		end
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',menu);		
	elseif(command == 6)
		Defaults.TextAlignment = data;
		set(get(Mom,'UserData'),'Checked','off');
		set(Mom,'UserData',menu);		
	end
else
	for(i=1:size(selectList,1))
		type = get(selectList(i,1),'Type');
		j = 1;
		if(strcmp(type,'text') | strcmp(type,'axes'))
			UndoList(2:end) = [];
			if(command == 1)
				UndoList(j).obj = selectList(i,1);
				UndoList(j).prop = 'FontName';
				UndoList(j).val = get(selectList(i,1),'FontName');
				set(selectList(i,1),'FontName',data);
				j = j+1;
			elseif(command == 2)
				UndoList(j).obj = selectList(i,1);
				UndoList(j).prop = 'FontAngle';
				UndoList(j).val = get(selectList(i,1),'FontAngle');
				set(selectList(i,1),'FontAngle',data);
				j = j+1;
			elseif(command == 3)
				UndoList(j).obj = selectList(i,1);
				UndoList(j).prop = 'FontWeight';
				UndoList(j).val = get(selectList(i,1),'FontWeight');
				set(selectList(i,1),'FontWeight',data);
				j = j+1;
			elseif(command == 4)
				UndoList(j).obj = selectList(i,1);
				UndoList(j+1).obj = selectList(i,1);
				UndoList(j).prop = 'FontWeight';
				UndoList(j).val = get(selectList(i,1),'FontWeight');
				UndoList(j+1).prop = 'FontAngle';
				UndoList(j+1).val = get(selectList(i,1),'FontAngle');
				set(selectList(i,1),'FontAngle','normal','FontWeight','normal');
				j = j+2;
			elseif(command == 5)
				UndoList(j).obj = selectList(i,1);
				UndoList(j).prop = 'FontSize';
				UndoList(j).val = get(selectList(i,1),'FontSize');
				if(data == 0)
					txtsize = inputdlg('Font Size?','MatDraw',1);
					if(isempty(txtsize))
						return;
					else
						txtsize = str2num(txtsize{1});
						if(isempty(txtsize))
							errordlg('Font size must be numeric!');
							return;
						end
					end			
					set(selectList(i,1),'FontSize',txtsize);
				else
					set(selectList(i,1),'FontSize',data);
				end
				j = j + 1;
			elseif(command == 6)
				UndoList(j).obj = selectList(i,1);
				UndoList(j).prop = 'HorizontalAlignment';
				UndoList(j).val = get(selectList(i,1),'HorizontalAlignment');
				set(selectList(i,1),'HorizontalAlignment',data);
				j = j + 1;
			end
		end
	end
	UndoList(j:end) = [];
	MDDatObjs.Undo = UndoList;
end
