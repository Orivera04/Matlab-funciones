function movetext(command)
% FUNCTION MOVETEXT(COMMAND)
% This is a callback designed to be called by a
% WindowButtonDown event.  COMMAND dictates the
% function's behavior. Basically, the function 
% handles mouse-controlled movement and rotation
% of text.
%
% Keith Rogers 9/26/94

global MDDatObjs;

if(nargin == 0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ButtonDown Behavior:
% If SelectionType is open, create 
% EDIT uicontrol to edit the text.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	obj = gco;
	ext = getset(obj,'Extent','Units','Normalized');
	axobj = get(obj,'Parent');
	cp = getset(gcf,'CurrentPoint','Units','Normalized');
	axpos = getset(axobj,'Position','Units','Normalized');
	cp = (cp-axpos(1:2))./axpos(3:4);
	UndoList = MDDatObjs.Undo;
	UndoList(1).obj = obj;
	if(strcmp(get(gcf,'SelectionType'),'open'))
		set(obj,'editing','on');
		% Set Undo Info
		
		UndoList(1).prop = 'String';
		UndoList(1).val = get(obj,'String');
		UndoList(2:end) = [];
		MDDatObjs.Undo = UndoList;	
	else
		set(obj,'EraseMode','xor');
		if((cp(1)<(ext(1)+.2*ext(3)) | cp(1)>(ext(1)+.8*ext(3))) &...
		   (cp(2)<(ext(2)+.2*ext(4)) | cp(2)>(ext(2)+.8*ext(4))))
				
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Set up functions for a text rotate
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			MDDatObjs.GenPurpHandle = get(obj,'Position');
			UndoList(1).prop = 'Rotation';
			UndoList(1).val = get(obj,'Rotation');
			UndoList(2:end) = [];
			
			set(gcf,'WindowButtonMotionFcn','movetext(1)',...
			'WindowButtonUpFcn','movetext(2)');
		
		else
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			% Set up functions for a text move
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
			xlog = strcmp(get(gca,'XScale'),'log');
			ylog = strcmp(get(gca,'YScale'),'log');
			cp = get(gca,'CurrentPoint');
			pos = get(obj,'Position');
			if(xlog)
				delta(1) = cp(1,1)/pos(1);
			else
				delta(1) = cp(1,1)-pos(1);
			end
			if(ylog)
				delta(2) = cp(1,2)/pos(2);
			else
				delta(2) = cp(1,2)-pos(2);
			end
			UndoList(1).prop = 'Position';
			UndoList(1).val = get(obj,'Position');
			UndoList(2:end) = [];
			set(gcf,'WindowButtonMotionFcn','movetext(3)');
			set(gcf,'WindowButtonUpFcn','movetext(2)');
			set(obj,'Units','Data');
			MDDatObjs.GenPurpHandle = [xlog ylog;delta];
		end
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do the rotate (this is for WindowButtonMotionFcn) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 1)
	cp = get(gca,'CurrentPoint');
	movetext_pos = MDDatObjs.GenPurpHandle;
	theta=atan2(cp(1,2)-movetext_pos(2),cp(1,1)-movetext_pos(1));
	if(strcmp(get(gcf,'SelectionType'),'extend'))
		set(gco,'rotation',180/12*round(12/pi*theta));
	else
		set(gco,'rotation',180/pi*theta);
	end
	
%%%%%%%%%%%%%%%%%%%%
% WindowButtonUpFcn 
%%%%%%%%%%%%%%%%%%%%

elseif(command == 2)
		set(gco,'erasemode','normal');
		set(gcf,'WindowButtonMotionFcn','',... 
		        'WindowButtonUpFcn','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do the Text Move (this is for WindowButtonMotionFcn) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif(command == 3)
	data = MDDatObjs.GenPurpHandle;
	cp = get(gca,'CurrentPoint');
	newpos = cp(1,:);
	if(data(1,1))
		newpos(1) = cp(1,1)/data(2,1);
	else
		newpos(1) = cp(1,1)-data(2,1);
	end
	if(data(1,2))
		newpos(2) = cp(1,2)/data(2,2);
	else
		newpos(2) = cp(1,2)-data(2,2);
	end
	set(gco,'Position',newpos);
end
