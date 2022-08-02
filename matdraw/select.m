function select(command,position)
% Function select(command,position)
% This is a callback function, and should not be
% called directly!
%
% Keith Rogers  2/95
%
% Mods: 

% Copyright (c) 1997 by Keith Rogers

% Get Data Storage Space from the Palette
% MDDatObjs(1): Reserved for Palette  
% MDDatObjs(2): Reserved for Palette 
% MDDatObjs.SelectList: Currently selected object
% MDDatObjs.RefLoc: Reference Location
% MDDatObjs.Defaults: Defaults
% MDDatObjs.GenPurpHandle: general purpose handle space
% MDDatObjs.MenuList: Menu handles for enabling/disabling
% MDDatObjs.Undo: Undo List
% MDDatObjs.UndoClipboard: Undo Clipboard
% MDDatObjs.Clipboard: Primary Clipboard
% MDDatObjs.GP2: 
% MDDatObjs.GP3: 
% MDDatObjs.UndoII: 

global MDDatObjs;
ShowHiddenHandles = get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
obj = gco;
fig = gcf;

if(nargin < 1)
	SelColor = MDDatObjs.Defaults.SelectionColor;
	SelectList = MDDatObjs.SelectList;
	type = get(gco,'Type');
	if(isempty(SelectList))
		if(~strcmp(type,'figure')) 
			set(obj,'Selected','on');  
			if(strcmp(type,'line')) 
				MDDatObjs.SelectList = [obj get(obj,'Color')];
				set(obj,'Color',SelColor);
			elseif(strcmp(type,'patch'))
				EdgeColor = get(obj,'EdgeColor');
				if(isstr(EdgeColor))
					if(EdgeColor(1) == 'n')  % 'none'
						MDDatObjs.SelectList = [obj -1 -1 -1];
					elseif(EdgeColor(1) == 'f')  % 'flat'
						MDDatObjs.SelectList = [obj -2 -2 -2];
					elseif(EdgeColor(1) == 'i')  % 'interp'
						MDDatObjs.SelectList = [obj -3 -3 -3];
					end
				else
					MDDatObjs.SelectList = [obj EdgeColor];
				end
				set(obj,'EdgeColor',SelColor);
			else
				MDDatObjs.SelectList = [obj zeros(1,3)]; %Add obj to select list
			end
		end
	else
		% Handle Shift-clicking to select multiple objects
		
		if(strcmp(get(gcf,'SelectionType'),'extend'))

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% If obj is already selected
	%        DESELECT IT
	% 1) If this is the only object selected then we must
	%    check to make see if the object has a special 
	%    "extended" property that has been activated.
	%    If so, then we do *not* deselect.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

			if(any(SelectList(:,1)==obj)) 
				flag = 0;
				if(size(SelectList,1) == 1)    
					if(strcmp(type,'text'))
						movetext;
						flag = 1;
					elseif(strcmp(type,'line') | strcmp(get(obj,'Tag'),'Arrow'))
						select(12);
						flag = 1;
					elseif(strcmp(type,'patch'))
						select(13);
						flag = 1;
					end
				end
				if(~flag) % Then nothing special happened, so just deselect obj
					if(ishandle(obj))
						set(obj,'Selected','off');
						if(strcmp(type,'line'))
							set(obj,'Color',SelectList(find(SelectList(:,1)==obj),2:4));
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
					SelectList = SelectList(find(SelectList(:,1)~=obj),:);  %Remove obj from select list
					MDDatObjs.SelectList = SelectList;
				end
				
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%   Still doing actions for EXTEND click
	%
	% If OBJ is not selected, SELECT it
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

			elseif(~strcmp(type,'figure')) 
				set(obj,'Selected','on');  
				if(strcmp(type,'line')) 
					MDDatObjs.SelectList = [SelectList; obj get(obj,'Color')];
					set(obj,'Color',SelColor);
				elseif(strcmp(type,'patch'))
					EdgeColor = get(obj,'EdgeColor');
					if(isstr(EdgeColor))
						if(EdgeColor(1) == 'n')  % 'none'
							MDDatObjs.SelectList = [SelectList; obj -1 -1 -1];
						elseif(EdgeColor(1) == 'f')  % 'flat'
							MDDatObjs.SelectList = [SelectList; obj -2 -2 -2];
						elseif(EdgeColor(1) == 'i')  % 'interp'
							MDDatObjs.SelectList = [SelectList; obj -3 -3 -3];
						end
					else
						MDDatObjs.SelectList = [SelectList; obj EdgeColor];
					end
					set(obj,'EdgeColor',SelColor);
				else
					MDDatObjs.SelectList = [SelectList; obj zeros(1,3)]; %Add obj to select list
				end
				
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%			
	% Extend-clicking on on an axes just selects it.
	% To DESELECT EVERYTHING click outside the axes
	% so that OBJ is the current figure
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

			else 
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
			
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%			
	% On to NORMAL clicking...
	% If OBJ is *not* selected
	% 1) Deselect everything else
	% 2) Select OBJ (Unless it's a figure).
	%    This, for now, just means adding it
	%    to the select list and changing its
	%    pen color for lines and patches.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		elseif(~any(SelectList(:,1)==obj))
			for(i=1:size(SelectList,1)) %Deselect everything but obj.
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
			set(obj,'Selected','on');  %select obj.
			if(strcmp(type,'line')) 
				MDDatObjs.SelectList = [obj get(obj,'Color')];
				set(obj,'Color',SelColor);
			elseif(strcmp(type,'patch'))
				EdgeColor = get(obj,'EdgeColor');
				if(isstr(EdgeColor))
					if(EdgeColor(1) == 'n')  % 'none'
						MDDatObjs.SelectList = [obj -1 -1 -1];
					elseif(EdgeColor(1) == 'f')  % 'flat'
						MDDatObjs.SelectList = [obj -2 -2 -2];
					elseif(EdgeColor(1) == 'i')  % 'interp'
						MDDatObjs.SelectList = [obj -3 -3 -3];
					end
				else
					MDDatObjs.SelectList = [obj EdgeColor];
				end
				set(obj,'EdgeColor',SelColor);
			elseif(~strcmp(type,'figure'))
				MDDatObjs.SelectList = [obj zeros(1,3)]; %Add obj to select list
			else %OBJ is a figure, so deselect everything
				MDDatObjs.SelectList = [];
			end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	%We've established that OBJ is already selected
	%If OBJ is just one of many, then we get to 
	%          MOVE THE WHOLE GROUP	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
		
		elseif(size(SelectList,1) > 1 & ~strcmp(get(obj,'Type'),'axes'))
			set(gcf,'WindowButtonMotionFcn','select(9)');
			set(gcf,'WindowButtonUpFcn','select(10)');
			MDDatObjs.RefLoc = get(gca,'CurrentPoint');
			j = 1;
			for(i=1:size(SelectList,1))
				typ = get(SelectList(i,1),'Type');
				if(strcmp(typ,'line') | strcmp(typ,'patch'))
					UndoList(j).obj = SelectList(i,1);
					UndoList(j+1).obj = SelectList(i,1);
					UndoList(j).prop = 'XData';
					UndoList(j).val = get(SelectList(i,1),'XData');
					UndoList(j+1).prop = 'YData';
					UndoList(j+1).val = get(SelectList(i,1),'YData');
					set(SelectList(i,1),'EraseMode','xor');
					j = j+2;
				elseif(strcmp(typ,'text'))
					UndoList(j).obj = SelectList(i,1);
					UndoList(j).prop = 'Position';
					UndoList(j).val = get(SelectList(i,1),'Position');
	   				set(SelectList(i,1),'EraseMode','xor');
					j = j+1;
				end
				UndoList(j:end) = [];
			end
			MDDatObjs.Undo = UndoList;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
	% Having eliminated all other possibilities, we now
	% go to procedures for when a single, already selected
	% object has been clicked on.  This includes moving,
	% reshaping, and otherwise editing the objects.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
			
		elseif(strcmp(type,'text'))
			
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Selected object is text
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
			movetext;	
				
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Selected object is a box or ellipse
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
				
		elseif(strcmp(type,'patch') & (strcmp(get(obj,'Tag'),'MDBox') | strcmp(get(obj,'Tag'),'MDEllipse')))
		
			select(13);
			
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Selected object is a 2 point line
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		elseif(strcmp(type,'line') | strcmp(get(obj,'Tag'),'Arrow'))
			select(12);
		end
	end
elseif(command == 1)
	p = get(gca,'CurrentPoint');
	set(obj,'Units','data','Position',[p(1,1) p(1,2) p(1,3)]);
elseif(command == 2)
	set(obj,'erasemode','normal');
	set(fig,'WindowButtonMotionFcn','');
	set(fig,'WindowButtonUpFcn','');
elseif(command == 3)  % Resize Line
	cp = get(gca,'CurrentPoint');
	XData = get(obj,'XData');
	YData = get(obj,'YData');
	if(strcmp(get(obj,'Tag'),'Arrow'))
		XData = [XData(6) XData(1)];
		YData = [YData(6) YData(1)];
	end
	ax = axis;
	dx = ax(2)-ax(1);
	dy = ax(4)-ax(3);
	NX = XData/dx;
	NY = YData/dy;
	if(strcmp(get(gcf,'SelectionType'),'extend'))
		s32 = .5*sqrt(3);
		s22 = .5*sqrt(2);
		Pmat = [1.0  0.0;  s32  0.5;  s22  s22;  0.5  s32;
		        0.0  1.0; -0.5  s32; -s22  s22; -s32  0.5;
		       -1.0  0.0; -s32 -0.5; -s22 -s22; -0.5 -s32;
		        0.0 -1.0;  0.5 -s32;  s22 -s22;  s32 -0.5];
		proj = Pmat*[cp(1,1)/dx-NX(1);cp(1,2)/dy-NY(1)];
		[m,i] = max(proj);
		m = m*Pmat(i,:);
		XData(1) = XData(2)+m(1)*dx;
		YData(1) = YData(2)+m(2)*dy;
	else
		XData(1) = cp(1,1);
		YData(1) = cp(1,2);
	end
	if(strcmp(get(obj,'Tag'),'Arrow'))
		arrow(obj,'Start',[XData(1) YData(1)]);
	else
		set(obj,'XData',XData,'YData',YData);
	end
elseif(command == 4)  % Resize Line
	cp = get(gca,'CurrentPoint');
	XData = get(obj,'XData');
	YData = get(obj,'YData');
	if(strcmp(get(obj,'Tag'),'Arrow'))
		XData = [XData(6) XData(1)];
		YData = [YData(6) YData(1)];
	end
	ax = axis;
	dx = ax(2)-ax(1);
	dy = ax(4)-ax(3);
	NX = XData/dx;
	NY = YData/dy;
	if(strcmp(get(gcf,'SelectionType'),'extend'))
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
	else
		XData(2) = cp(1,1);
		YData(2) = cp(1,2);
	end
	if(strcmp(get(obj,'Tag'),'Arrow'))
		arrow(obj,'Stop',[XData(2) YData(2)]);
	else
		set(obj,'XData',XData,'YData',YData);
	end
elseif(command == 5)  % Move Line or Box
	data = MDDatObjs.RefLoc;
		
	cp = get(gca,'CurrentPoint');
	XData = get(obj,'XData');
	YData = get(obj,'YData');
	if(data(1,2)) %xlog
		XData = XData*cp(1,1)/data(1,1);
	else
		XData = XData+cp(1,1)-data(1,1);
	end
	if(data(2,2)) %ylog
		YData = YData*cp(1,2)/data(2,1);
	else
		YData = YData+cp(1,2)-data(2,1);
	end
	set(obj,'XData',XData,'YData',YData);
	MDDatObjs.RefLoc = [cp(1,1) data(1,2);cp(1,2) data(2,2)];
elseif(command == 6)  % Finished with Line, Box, or Circle
	if(strcmp(get(obj,'Tag'),'Arrow'))
		UserData = get(obj,'UserData');
		XData = get(obj,'XData');
		YData = get(obj,'YData');
		ZData = get(obj,'ZData');
		if(isempty(ZData))
			ZData = NaN*ones(size(XData));
		end
		UserData(1:6) = [XData(6) YData(6) ZData(6) XData(1) YData(1) ZData(1)];
		set(obj,'UserData',UserData);
	end
	set(obj,'EraseMode','normal');
	set(fig,'WindowButtonMotionFcn','');
	set(fig,'WindowButtonUpFcn','');
	delete(findobj('Tag','3D Resize'));
elseif(command == 7) % Resize Box from corner
	ext = MDDatObjs.RefLoc;
	cp = get(gca,'CurrentPoint');
	if(position == 1)
		ext = [cp(1,1:2) ext(1:2)+ext(3:4)-cp(1,1:2)];
	elseif(position == 2)
		ext = [cp(1,1) ext(2) ext(1)+ext(3)-cp(1,1) cp(1,2)-ext(2)];
	elseif(position == 3)
		ext(3:4) = cp(1,1:2)-ext(1:2);
	else
		ext(2:4) = [cp(1,2) cp(1,1)-ext(1) ext(2)+ext(4)-cp(1,2)];
	end
	XData = ext(1)+[0 ext(3) ext(3) 0 0];
	YData = ext(2)+[0 0 ext(4) ext(4) 0];
	if(length(get(obj,'XData')) ~= 5)  % true for a Ellipse
		ax = axis;
		defaults = MDDatObjs.Defaults;
		numpts = defaults.CirclePoints;
		[XData, YData] = ellipse(ext,numpts,ax);
	end
	set(obj,'XData',XData,'YData',YData);
elseif(command == 8) % Resize box from edge
	ext = MDDatObjs.RefLoc;
	cp = get(gca,'CurrentPoint');
	if(position == 1)
		ext = [cp(1,1) ext(2) ext(1)+ext(3)-cp(1,1) ext(4)];
	elseif(position == 2)
		ext = [ext(1) ext(2) ext(3) cp(1,2)-ext(2)];
	elseif(position == 3)
		ext = [ext(1) ext(2) cp(1,1)-ext(1) ext(4)];
	else
		ext = [ext(1) cp(1,2) ext(3) ext(2)+ext(4)-cp(1,2)];
	end
	XData = ext(1)+[0 ext(3) ext(3) 0 0];
	YData = ext(2)+[0 0 ext(4) ext(4) 0];
	if(length(get(obj,'XData')) ~= 5)  % true for a Ellipse
		ax = axis;
		defaults = MDDatObjs.Defaults;
		numpts = defaults.CirclePoints;
		[XData, YData] = ellipse(ext,numpts,ax);
	end
	set(obj,'XData',XData,'YData',YData);	
elseif(command == 9) % Move a bunch of objects
	SelectList = MDDatObjs.SelectList;
	startpoint = MDDatObjs.RefLoc;
	xlog = strcmp(get(gca,'XScale'),'log');
	ylog = strcmp(get(gca,'YScale'),'log');
	cp = get(gca,'CurrentPoint');
	for(i=1:size(SelectList,1))
		typ = get(SelectList(i,1),'Type');
		if(strcmp(typ,'line') | strcmp(typ,'patch'))
			XData = get(SelectList(i,1),'XData');
			YData = get(SelectList(i,1),'YData');
			XData = XData+cp(1,1)-startpoint(1,1);
			YData = YData+cp(1,2)-startpoint(1,2);
			set(SelectList(i,1),'XData',XData,'YData',YData);
		elseif(strcmp(typ,'text'))
			pos = get(SelectList(i,1),'Position'); newpos = pos;
			if(xlog)
				newpos(1) = pos(1)*cp(1,1)/startpoint(2,1);
			else
				newpos(1) = pos(1)+cp(1,1)-startpoint(2,1);
			end
			if(ylog)
				newpos(2) = pos(2)*cp(1,2)/startpoint(2,2);
			else
				newpos(2) = pos(2)+cp(1,2)-startpoint(2,2);
			end
			set(SelectList(i,1),'Position',newpos);
		end
	end
	MDDatObjs.RefLoc = cp;
elseif(command == 10) % ButtonUpFcn for above	
	SelectList = MDDatObjs.SelectList;
	Arrows = findobj(SelectList(:,1),'Tag','Arrow');
	for(i=1:length(Arrows))
		UserData = get(Arrows(i),'UserData');
		XData = get(Arrows(i),'XData');
		YData = get(Arrows(i),'YData');
		ZData = get(Arrows(i),'ZData');
		if(isempty(ZData))
			ZData = NaN*ones(size(XData));
		end
		UserData(1:6) = [XData(6) YData(6) ZData(6) XData(1) YData(1) ZData(1)];
		set(Arrows(i),'UserData',UserData);
	end
	set(gcf,'WindowButtonMotionFcn','');
	set(gcf,'WindowButtonUpFcn','');
	for(i=1:size(SelectList,1))
		set(SelectList(i,1),'EraseMode','normal');
	end
elseif(command == 11)
	char = get(gcf,'CurrentCharacter');
	if(~isempty(char))
	if(strcmp(computer,'SUN4') | strcmp(computer,'SOL2') | ...
	   strcmp(computer,'SGI64'))
		if(char == 127)
			edtcback(5);
		end
	elseif(char == 8)
		edtcback(5);
	end
	if(char == '+' | char == 'T' | char == '/' |...
		   char == 'O' | char == '#')
		drwcback(char);
	elseif(char > '0' & char <= '9')
		axlist = findobj(gcf,'Type','axes','Visible','on');
		numaxes = length(axlist);
		if(numaxes > 1 & char-'0' <= numaxes)
			axpos = zeros(numaxes,2);
			for(i=1:numaxes)
				pos = get(axlist(i),'Position');
				axpos(i,:) = pos(2:-1:1);
			end
			[s,ind] = sort(axpos(:,1));
			axlist = axlist(ind(numaxes:-1:1));
			axpos = axpos(ind(numaxes:-1:1),:);
			for(i=1:numaxes-1)
				if(axpos(i,1) == axpos(i+1))
					if(axpos(i,2) > axpos(i+1,2))
						axlist(i:i+1) = axlist(i+1:-1:i);
					end
				end
			end
			set(gcf,'CurrentAxes',axlist(char-'0'));
		end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB's interpretation of what happens when you press
% an arrow key varies significantly from platform to 
% platform.  On the my Macintosh, hitting the left arrow
% produces code 28, the right arrow produces code 29, and
% the up and down arrows produce codes 30 and 31 respectively.
% When connecting to the local Sparc Station via Exodus,
% the arrows on my Mac's keyboard don't seem to be recognized
% at all.  So I've added in recognition for the standard 
% unix cursor motion keys: h, l, j, and k, instead. These
% will work on all platforms, and on the Macintosh (and any
% other platforms which recognize them) the arrow keys can
% be used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	elseif(length(axis) == 4) 
	if(char == 28 | char == 104)  % Left Arrow or 'h' 
			xtick = get(gca,'Xtick');
			dx = xtick(2)-xtick(1);
			ax = axis;
			ax(1) = ax(1)-dx;
			ax(2) = ax(2)-dx;
			axis(ax);
		elseif(char == 29 | char == 108)  % Right Arrow or 'l'
			xtick = get(gca,'Xtick');
			dx = xtick(2)-xtick(1);
			ax = axis;
			ax(1) = ax(1)+dx;
			ax(2) = ax(2)+dx;
			axis(ax);
		elseif(char == 30 | char == 106)  % Up Arrow or 'k'
			ytick = get(gca,'Ytick');
			dy = ytick(2)-ytick(1);
			ax = axis;
			ax(3) = ax(3)+dy;
			ax(4) = ax(4)+dy;
			axis(ax);
		elseif(char == 31 | char == 107)  % Down Arrow or 'j'
			ytick = get(gca,'Ytick');
			dy = ytick(2)-ytick(1);
			ax = axis;
			ax(3) = ax(3)-dy;
			ax(4) = ax(4)-dy;
			axis(ax);
		end
	end
	end
elseif(command == 12)
	XData = get(obj,'XData');
	YData = get(obj,'YData');
	if(strcmp(get(obj,'Tag'),'Arrow'))
		XData = [XData(6) XData(1)];
		YData = [YData(6) YData(1)];
	end
	if(length(XData) == 2)
		ax = axis;
		cp = get(gca,'CurrentPoint');
		set(obj,'EraseMode','xor');
		if(length(ax) == 6)
			ZData = get(obj,'ZData');
			if(isempty(ZData))
					ZData = [0 0];
			end
			if(strcmp(get(obj,'Tag'),'Arrow'))
				ZData = [ZData(6) ZData(1)];
			end
			p1 = [XData(1) YData(1) ZData(1)];
			p2 = [XData(2) YData(2) ZData(2)];
			a = diff(cp);
			b = cp(1,:);
			t = -sum(a.*(b-p1))/(a*a');
			distToP1 = sqrt(sum(((b-p1)+a*t).^2));
			t = -a*(b-p2)'/(a*a');
			distToP2 = sqrt(sum(((b-p2)+a*t).^2));
			linelen = sqrt(a*a');
			if(distToP1 < .2*linelen)
				MDDatObjs.PickData.LineData.Handle = obj;
				MDDatObjs.PickData.LineData.Data = [XData;YData;ZData];
				MDDatObjs.PickData.LineData.Start = 1;
				set(fig,'WindowButtonUpFcn','select(6)');
				pick3d('3D Resize');
			elseif(distToP2 < .2*linelen)
				MDDatObjs.PickData.LineData.Handle = obj;
				MDDatObjs.PickData.LineData.Data = [XData;YData;ZData];
				MDDatObjs.PickData.LineData.Start = 2;
				set(fig,'WindowButtonUpFcn','select(6)');
				pick3d('3D Resize');
			end	
		else
			distToP1 = sqrt((cp(1,1)-XData(1))^2+(cp(1,2)-YData(1))^2);
			distToP2 = sqrt((cp(1,1)-XData(2))^2+(cp(1,2)-YData(2))^2);
			linelen = sqrt(diff(XData)^2+diff(YData)^2);
			if(distToP1 < .2*linelen)
				set(fig,'WindowButtonMotionFcn','select(3)');
			elseif(distToP2 < .2*linelen)
				set(fig,'WindowButtonMotionFcn','select(4)');
			else
				xlog = strcmp(get(gca,'XScale'),'log');
				ylog = strcmp(get(gca,'YScale'),'log');
				MDDatObjs.RefLoc = [cp(1,1) xlog;cp(1,2) ylog];
				set(fig,'WindowButtonMotionFcn','select(5)');
			end	
			set(fig,'WindowButtonUpFcn','select(6)');
		end
		
		% Set Undo Info
		
		UndoList = MDDatObjs.Undo;
		UndoList(3:end) = [];
		UndoList(1).obj = obj;
		UndoList(2).obj = obj;
		UndoList(1).prop = 'XData';
		UndoList(2).prop = 'YData';
		UndoList(1).val = get(obj,'XData');
		UndoList(2).val = get(obj,'YData');
		MDDatObjs.Undo = UndoList;
	end
elseif(command == 13)
	XData = get(obj,'XData');
	YData = get(obj,'YData');
	set(gco,'EraseMode','xor');
	cp = get(gca,'CurrentPoint');
	minx = min(XData);
	miny = min(YData);
	ext = [minx miny max(XData)-minx max(YData)-miny];
	MDDatObjs.RefLoc = ext;
	if(cp(1,1)<ext(1)+.2*ext(3))
		if(cp(1,2)<ext(2)+.2*ext(4)) 		% Lower Left Corner
			set(fig,'WindowButtonMotionFcn','select(7,1)');
		elseif(cp(1,2)>ext(2)+.8*ext(4)) 	% Upper Left Corner
			set(fig,'WindowButtonMotionFcn','select(7,2)');
		else								% Left Side
			set(fig,'WindowButtonMotionFcn','select(8,1)');
		end
	elseif(cp(1,1)>ext(1)+.8*ext(3))
		if(cp(1,2)<ext(2)+.2*ext(4)) 		% Lower Right Corner
			set(fig,'WindowButtonMotionFcn','select(7,4)');
		elseif(cp(1,2)>ext(2)+.8*ext(4)) 	% Upper Right Corner
			set(fig,'WindowButtonMotionFcn','select(7,3)');
		else								% Right Side
			set(fig,'WindowButtonMotionFcn','select(8,3)');
		end
	elseif(cp(1,2)>ext(2)+.8*ext(4))		% Top Side
			set(fig,'WindowButtonMotionFcn','select(8,2)')
	elseif(cp(1,2)<ext(2)+.2*ext(4))		% Bottom Side
			set(fig,'WindowButtonMotionFcn','select(8,4)')
	else									% Center
		xlog = strcmp(get(gca,'XScale'),'log');
		ylog = strcmp(get(gca,'YScale'),'log');
		MDDatObjs.RefLoc = [cp(1,1) xlog;cp(1,2) ylog];
		set(fig,'WindowButtonMotionFcn','select(5)');
	end
	set(fig,'WindowButtonUpFcn','select(2)');
	
	% Set Undo Info
	
	UndoList = MDDatObjs.Undo;
	UndoList(1).obj = obj;
	UndoList(2).obj = obj;
	UndoList(1).prop = 'XData';
	UndoList(2).prop = 'YData';
	UndoList(1).val = get(obj,'XData');
	UndoList(2).val = get(obj,'YData');
	UndoList(3:end) = [];
	MDDatObjs.Undo = UndoList;
end
set(0,'ShowHiddenHandles',ShowHiddenHandles);

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
