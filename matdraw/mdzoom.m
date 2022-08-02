function mdzoom(command)
% Zoom by a factor of maglevel
%
% Keith Rogers  11/93
%
% Mods:
%
% 12/13/94: Select Axes to show which one is being zoomed
%           Abort if click is outside selected axes.
%           Changed name to avoid conflict with Mathworks
%           zoom function
% 12/26/94  Major revision to add 3D picking and rbbox
%           functionality
% 12/28/94  Make rbbox function obey selected zoom axes

global MDDatObjs;
ZoomData = MDDatObjs.ZoomData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First, get the zoom point
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(isstr(command))

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Well, actually first we cover 
	% the ZOOM HOME functionality
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	if(strcmp(command,'home'))
		origlims = get(get(gca,'ylabel'),'UserData');
		if(~isempty(origlims))
			if(length(axis) > 4)
				ZDatHolder = findobj(gcf,'Label','Zoom In');
				zoom3d(origlims,ZDatHolder);
			else
				axis(origlims);
			end
		end
	elseif(strcmp(command,'in'))
		ZoomData.InOut = 1;
		MDDatObjs.ZoomData = ZoomData;
		mdzoom('Setup Pick')
	elseif(strcmp(command,'out'))
		ZoomData.InOut = 0;
		MDDatObjs.ZoomData = ZoomData;
		mdzoom('Setup Pick')
	elseif(strcmp(command,'Setup Pick'))
		if(strcmp(get(gcf,'interruptible'),'on'))
			ZoomData.Interruptible = 1;
		else
			ZoomData.Interruptible = 0;
		end
		MDDatObjs.ZoomData = ZoomData;
		set(gcf,'interruptible','on');
		ylabeldata = get(get(gca,'ylabel'),'UserData');
		if(isempty(ylabeldata) | length(ylabeldata) < length(axis))
			set(get(gca,'ylabel'),'UserData',axis);
		end
		set(gca,'selected','on');
		set(gcf,'pointer','crosshair');
		drawnow discard;
		
		%%%%%%%%%%%%%%%%%%%%
		% Setup for pick3d 
		%%%%%%%%%%%%%%%%%%%%

		MDDatObjs.ZoomData.Old.WindowButtonDownFcn = get(gcf,'WindowButtonDownFcn');
		if(length(axis) == 4)
			set(gcf,'WindowButtonDownFcn','mdzoom(''2D ButtonDown'')');
		else
			MDDatObjs.ZoomData.Old.WindowButtonUpFcn = get(gcf,'WindowButtonUpFcn');
			set(gcf,'WindowButtonUpFcn','mdzoom(''3D ButtonUp'')');
			MDDatObjs.PickData = [];
			set(gcf,'WindowButtonDownFcn','pick3d(''MatDraw Zoom'')');
		end
	elseif(strcmp(command,'2D ButtonDown'))	
		set(gca,'selected','off');
		set(gcf,'pointer','arrow');
		ax = axis;
		pt = get(gca,'CurrentPoint');
		pt = pt(1,1:2);
		figpt = get(gcf,'CurrentPoint');
		rbbox([figpt(1) figpt(2) 0 0],figpt)
		if(ZoomData.Interruptible == 0)
			set(gcf,'interruptible','off');
		end
		npt = get(gca,'CurrentPoint');
		npt = npt(1,1:2);
		if((abs(npt(1)-pt(1))<.01*(ax(2)-ax(1))) &...
			(abs(npt(2)-pt(2))<.01*(ax(4)-ax(3))))
			mdzoom(pt);
		else
			mdzoom([pt(1) pt(2) npt(1) npt(2)]);
		end
	elseif(strcmp(command,'3D ButtonUp'))	
		point = MDDatObjs.PickData.Point;
		mdzoom([point.x point.y point.z]);
		set(gcf,'WindowButtonUpFcn','');
	end
else

	% First, check to make sure the user has clicked inside the
	% selected axes.

	currax = axis;
	direction = ZoomData.InOut;
	pick = command;
	if(pick(1) > currax(1) & pick(1) < currax(2) & ...
		pick(2) > currax(3) & pick(2) < currax(4))

		% Now, check for rbbox data

		if(length(pick) == 4 & direction == 1)

			if(ZoomData.X)
				currax(1:2) = [min([pick(1) pick(3)]) max([pick(1) pick(3)])];
			end
			if(ZoomData.Y)
				currax(3:4) = [min([pick(2) pick(4)]) max([pick(2) pick(4)])];
			end
			axis(currax);   % and we're done!

		else
			plotobjs = get(gca,'Children');
			if (length(plotobjs) ~= 0)
				newax = zeros(size(currax));
				if (currax(1) == -inf)
					minx = inf;
				else
					minx = currax(1);
				end
				if (currax(2) == inf)
					maxx = -inf;
				else
					maxx = currax(2);
				end
				if (currax(3) == -inf)
					miny = inf;
				else
					miny = currax(3);
				end
				if (currax(4) == inf)
					maxy = -inf;
				else
					maxy = currax(4);
				end
				if(length(currax) > 4)
					if (currax(5) == -inf)
						minz = inf;
					else
						minz = currax(5);
					end
					if (currax(6) == inf)
						maxz = -inf;
					else
						maxz = currax(6);
					end
				end
				ZDatHolder = findobj(gcf,'Label','Zoom In');
				ObjList = get(ZDatHolder,'UserData');
				for(i=1:size(ObjList,1))
					if(~any(plotobjs == ObjList(i,2)))
						ObjList = ObjList(find(ObjList(:,2)~=ObjList(i,2)),:);
					end
				end
				if(length(currax) == 4 | isempty(ObjList))
					for(i=1:length(plotobjs))
						if(strcmp(get(plotobjs(i),'Type'),'line') | ...
						strcmp(get(plotobjs(i),'Type'),'surface'))
							Xdata = get(plotobjs(i),'Xdata');
							Xdata = Xdata(find(~isnan(Xdata)));
							Ydata = get(plotobjs(i),'Ydata');
							Ydata = Ydata(find(~isnan(Ydata)));
							minx = min([minx min(min(Xdata))]);
							maxx = max([maxx max(max(Xdata))]);
							miny = min([miny min(min(Ydata))]);
							maxy = max([maxy max(max(Ydata))]);
							if(length(currax) > 4)
								Zdata = get(plotobjs(i),'Zdata');
								Zdata = Zdata(find(~isnan(Zdata)));
								minz = min([minz min(min(Zdata))]);
								maxz = max([maxz max(max(Zdata))]);
							end
						end
					end
				else
					for(i=1:size(ObjList,1))
						Data =  get(ObjList(i,1),'UserData');
						if(strcmp(get(ObjList(i,2),'Type'),'line'))
							Xdata = Data(1,:);
							Xdata = Xdata(find(~isnan(Xdata)));
							Ydata = Data(2,:);
							Ydata = Ydata(find(~isnan(Ydata)));
							Zdata = Data(3,:);
							Zdata = Zdata(find(~isnan(Zdata)));
						elseif(strcmp(get(ObjList(i,2),'Type'),'surface'))
							m = size(Data,1)/4;
							Xdata = Data(1:m,:);
							Xdata = Xdata(find(~isnan(Xdata)));
							Ydata = Data(m+1:2*m,:);
							Ydata = Ydata(find(~isnan(Ydata)));
							Zdata = Data(2*m+1:3*m,:);
							Zdata = Zdata(find(~isnan(Zdata)));
						end
						minx = min([minx min(min(Xdata))]);
						maxx = max([maxx max(max(Xdata))]);
						miny = min([miny min(min(Ydata))]);
						maxy = max([maxy max(max(Ydata))]);
						minz = min([minz min(min(Zdata))]);
						maxz = max([maxz max(max(Zdata))]);
					end
				end

				zpx = pick(1);
				zpy = pick(2);

				%%%%%  Adjust Z Axis %%%%%

				if (length(currax) > 4)		% If 3-D plot
					zpz = pick(3);
					if (ZoomData.Z)	% Z Axis Zoom active
						if(direction == 1)
							newzsize = (min(maxz,currax(6))-max(minz,currax(5)))...
							/ZoomData.maglevel;
						else
							newzsize = (min(maxz,currax(6))-max(minz,currax(5)))...
							*ZoomData.maglevel;
						end
					else 
						newzsize = currax(6)-currax(5);
					end	
					if ((zpz-.5*newzsize) < minz)
						newax(5:6) = [minz minz+newzsize];
					elseif (zpz+.5*newzsize > maxz)
						newax(5:6) = [maxz-newzsize maxz];
					else
						newax(5:6) = [(zpz-.5*newzsize) (zpz+.5*newzsize)];
					end
				end

				%%%%%  Adjust X Axis   %%%%%

				if(ZoomData.X)				% X Axis Zoom active
					if(direction == 1)			% Zoom in
						newxsize = (min(maxx,currax(2))-max(minx,currax(1)))...
						/ZoomData.maglevel;
					else		                				% Zoom out
						newxsize = (min(maxx,currax(2))-max(minx,currax(1)))...
						*ZoomData.maglevel;
					end
				else
					newxsize = currax(2)-currax(1);
				end
				if ((zpx-.5*newxsize) < minx)
					newax(1:2) = [minx minx+newxsize];
				elseif (zpx+.5*newxsize > maxx)
					newax(1:2) = [maxx-newxsize maxx];
				else
					newax(1:2) = [(zpx-.5*newxsize) (zpx+.5*newxsize)];
				end

				%%%%%  Adjust Y Axis   %%%%%

				if(ZoomData.Y)	% Y Axis Zoom active
					if(direction == 1)			% Zoom in
						newysize = (min(maxy,currax(4))-max(miny,currax(3)))...
						/ZoomData.maglevel;
					else						% Zoom out
						newysize = (min(maxy,currax(4))-max(miny,currax(3)))...
						*ZoomData.maglevel;
					end
				else
					newysize = currax(4)-currax(3);
				end
				if ((zpy-.5*newysize) < miny)
					newax(3:4) = [miny miny+newysize];
				elseif (zpy+.5*newysize > maxy)
					newax(3:4) = [maxy-newysize maxy];
				else
					newax(3:4) = [(zpy-.5*newysize) (zpy+.5*newysize)];
				end
				if(length(currax) > 4)  % If 3D plot
					ZDatHolder = findobj(gcf,'Label','Zoom In');
					zoom3d(newax,ZDatHolder);
				else
					axis(newax);
				end
			end
		end
	end
	set(gca,'selected','off');
	set(gcf,'WindowButtonDownFcn',ZoomData.Old.WindowButtonDownFcn);
end
