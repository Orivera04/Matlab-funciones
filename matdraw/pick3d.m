function pick3d(command,StorageTag)
%Keith Rogers 05/03/95

%Copyright (c) 1995 by Keith Rogers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% storage(1):  Old WindowButtonDownFcn
% storage(2):  Old WindowButtonMotionFcn
% storage(3):  Old WindowButtonUpFcn
% storage(4):  UserData
%           :  (1)  Xline
%           :  (2)  Yline
%           :  (3)  Zline
%           :  (4)  Px
%           :  (5)  Py
%           :  (6)  Pz
% storage(5):  Optional - Handle
% storage(6):  Optional - Data
% storage(7):  Optional - Start/End indicator
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(nargin < 2)
	StorageTag = command;
end
global MDDatObjs
if(~isfield(MDDatObjs.PickData,'Old'));
	MDDatObjs.PickData.Old = [];
	MDDatObjs.PickData.Point = [];
end
if(~isfield(MDDatObjs.PickData,'Guides'));
	MDDatObjs.PickData.Guides.x = [];
	MDDatObjs.PickData.Guides.y = [];
	MDDatObjs.PickData.Guides.z = [];
end
if(~isfield(MDDatObjs.PickData,'Point'));
	MDDatObjs.PickData.Point.x = [];
	MDDatObjs.PickData.Point.y = [];
	MDDatObjs.PickData.Point.z = [];
end
Old = MDDatObjs.PickData.Old;
Guides = MDDatObjs.PickData.Guides;
Point = MDDatObjs.PickData.Point;


if(isstr(command))  % Setup

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Store old ButtonFcn's so we  %
	% can restore them when we are %
	% done.                        %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	Old.WindowButtonDownFcn = get(gcf,'WindowButtonDownFcn');
	Old.WindowButtonMotionFcn = get(gcf,'WindowButtonMotionFcn');
	Old.WindowButtonUpFcn = get(gcf,'WindowButtonUpFcn');

	set(gcf,'pointer','crosshair');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set new ButtonFcn's according   %
	% to specifications passed to us. %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	set(gcf,'WindowButtonMotionFcn','pick3d(1)');
	set(gcf,'WindowButtonDownFcn','pick3d(2)');
	set(gcf,'WindowButtonUpFcn','');
	ax = axis;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Set up Initial X, Y, and Z coordinates.    %
	% If storage(5-7) exist, then  we are        %
	% picking for a line, and have to set up the %
	% Z info accordingly.                        %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	set(gcf,'units','normalized');
	pt = get(gcf,'CurrentPoint');
	Point.x = pt(1,1)*(ax(2)-ax(1))+ax(1);
	Point.y = pt(1,2)*(ax(4)-ax(3))+ax(3);
	if(isfield(MDDatObjs.PickData,'LineData'))
		Data = MDDatObjs.PickData.LineData.Data;
		if(MDDatObjs.PickData.LineData.Start==1)
			Point.z = Data(3,1);
		else
			Point.z = Data(3,2);
		end
	else
		Point.z = (ax(5)+ax(6))/2;
	end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Draw the 3-D Crosshairs %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

	Guides.x = line('Xdata',[ax(1);ax(1);ax(2);ax(2);ax(1);ax(1);ax(2)],...
					 'Ydata',[Point.y ax(3) ax(3) ax(4) ax(4) Point.y Point.y],...
					 'Zdata',Point.z*ones(7,1),'linewidth',2,...
				 'LineStyle',':','Color','k','Erasemode','xor');
	Guides.y = line('Xdata',Point.x*ones(7,1),'linewidth',2,...
					 'Ydata',[ax(3);ax(3);ax(4);ax(4);ax(3);ax(3);ax(4)],...
					 'Zdata',[Point.z;ax(5);ax(5);ax(6);ax(6);Point.z;Point.z],...
				  'LineStyle',':','Color','k','Erasemode','xor');
	Guides.z = line('Xdata',[Point.x;ax(1);ax(1);ax(2);ax(2);Point.x;Point.x],...
					 'Ydata',Point.y*ones(7,1),'linewidth',2,...
					 'Zdata',[ax(5);ax(5);ax(6);ax(6);ax(5);ax(5);ax(6)],...
				  'LineStyle',':','Color','k','Erasemode','xor');

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Change color on Mac to cope with color bugginess. %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 	if(strcmp(computer,'MAC2'))
% 		set([xline yline zline],'Color','r');
% 	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Animate the line if we are %
	% resizing something.        %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if(isfield(MDDatObjs.PickData,'LineData'))
		set(MDDatObjs.PickData.LineData.Handle,'EraseMode','xor');
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Store handles and coords. %
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
	MDDatObjs.PickData.Old = Old;
	MDDatObjs.PickData.Point = Point;
	MDDatObjs.PickData.Guides = Guides;

elseif (command == 1)

	%%%%%%%%%%%%%%%%%%%%%%%
	% ButtonDown Callback %
	%%%%%%%%%%%%%%%%%%%%%%%

	ax = axis;
	pt = get(gcf,'CurrentPoint');
	if(strcmp(get(gcf,'SelectionType'),'alt'))
		Point.z = pt(2)*(ax(6)-ax(5))+ax(5);
		set(Guides.x,'ZData',Point.z*ones(7,1));
		YZData = get(Guides.y,'ZData');
		YZData([1 6 7]) = Point.z*ones(3,1);
		set(Guides.y,'ZData',YZData);
		if(isfield(MDDatObjs.PickData,'LineData'))
			obj = MDDatObjs.PickData.LineData.Handle;
			objdata = MDDatObjs.PickData.LineData.Data;
			StartStop = MDDatObjs.PickData.LineData.Start;
			if(StartStop == 1)
				objdata(3,1) = Point.z;
			else
				objdata(3,2) = Point.z;
			end
			if(strcmp(get(obj,'Tag'),'Arrow'))
				arrow(obj,'Start',objdata(:,1),'Stop',objdata(:,2));
			else
				set(obj,'ZData',objdata(3,:));
			end
			MDDatObjs.PickData.LineData.Data = objdata;
		end
		MDDatObjs.PickData.Point = Point;
	else
		Point.x = pt(1,1)*(ax(2)-ax(1))+ax(1);
		Point.y = pt(1,2)*(ax(4)-ax(3))+ax(3);
		set(Guides.x,'Ydata',[Point.y ax(3) ax(3) ax(4) ax(4) Point.y Point.y]);
		set(Guides.y,'XData',Point.x*ones(7,1));
		set(Guides.z,'XData',[Point.x;ax(1);ax(1);ax(2);ax(2);Point.x;Point.x],...
							 'YData',Point.y*ones(7,1));
		if(isfield(MDDatObjs.PickData,'LineData'))
			obj = MDDatObjs.PickData.LineData.Handle;
			objdata = MDDatObjs.PickData.LineData.Data;
			StartStop = MDDatObjs.PickData.LineData.Start;
			if(StartStop == 1)
				objdata(1:2,1) = [Point.x;Point.y];
			else
				objdata(1:2,2) = [Point.x;Point.y];
			end
			if(strcmp(get(obj,'Tag'),'Arrow'))
				arrow(obj,'Start',objdata(:,1),'Stop',objdata(:,2));
			else
				set(obj,'XData',objdata(1,:),'YData',objdata(2,:));
			end
			MDDatObjs.PickData.LineData.data = objdata;
		end
		MDDatObjs.PickData.Point = Point;
	end
elseif(command == 2)
	if(strcmp(get(gcf,'SelectionType'),'extend'))
		delete(Guides.x);
		delete(Guides.y);
		delete(Guides.z);
		set(gcf,'WindowButtonUpFcn',Old.WindowButtonUpFcn,...
				'WindowButtonMotionFcn',Old.WindowButtonMotionFcn,...
				'WindowButtonDownFcn',Old.WindowButtonDownFcn);
		if(isfield(MDDatObjs.PickData,'LineData'))
			obj = MDDatObjs.PickData.LineData.Handle;
			set(gcf,'pointer','arrow','currentobject',obj);
			MDDatObjs.PickData = rmfield(MDDatObjs.PickData,'LineData');
			disp('Field Removed');
		end
	end
end
