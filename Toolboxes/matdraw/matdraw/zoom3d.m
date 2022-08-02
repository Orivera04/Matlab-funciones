function objdata = zoom3d(newlims,DataObj)
% Issues:
% Must save data for each surface object
% What about line objects?
% What about new plots after a zoom?

global MDDatObjs

if(~isfield(MDDatObjs.ZoomData,'objdata'));
	MDDatObjs.ZoomData.objdata = [];
end
objdata = MDDatObjs.ZoomData.objdata;
kids = get(gca,'Children');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove nonexistent or irrelevant %
% objects from objdata list        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for(i=1:length(objdata))
	if(~any(kids == objdata(i).handle))
		objdata(i) = [];
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store Objects that have not yet been stored %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for(i = 1:length(kids))
	stored = 0;
	for(j=1:length(objdata))
		if(kids(i) == objdata(j).handle)
			stored = 1;
		end
	end
	if(~stored)  % If unstored surface
		ind = length(objdata)+1;
	else
		break;
	end
	if(strcmp(get(kids(i),'Type'),'surface'))
		objdata(ind).handle = kids(i) ;
		XD = get(kids(i),'XData');
		YD = get(kids(i),'YData');
		if(min(size(XD)) == 1)
			XD = XD(ones(size(YD,1),1),:);
		end
		if(min(size(YD)) == 1)
			YD = YD(:,ones(1,size(XD,2)));
		end
		objdata(ind).XD = XD;
		objdata(ind).YD = YD;
		objdata(ind).ZD = get(kids(i),'ZData');
		objdata(ind).CD = get(kids(i),'CData');

	elseif(strcmp(get(kids(i),'Type'),'line'))
		objdata(ind).handle = kids(i);
		objdata(ind).XD = get(kids(i),'XData');
		objdata(ind).YD = get(kids(i),'YData');
		objdata(ind).ZD = get(kids(i),'ZData');
	end
end
MDDatObjs.ZoomData.objdata = objdata;
if(ishold)
	h = 1;
else
	h = 0;
end
hold on;

%%%%%%%%%%%%%%%
% Do the ZOOM %
%%%%%%%%%%%%%%%

for(i = 1:length(objdata))
	if(~isempty(objdata(i).CD))
		X = objdata(i).XD;
		Y = objdata(i).YD;
		Z = objdata(i).ZD;
		C = objdata(i).CD;
		Xlims = find((X(1,:) > newlims(1)) & (X(1,:) < newlims(2)));
		Ylims = find((Y(:,1) > newlims(3)) & (Y(:,1) < newlims(4)));
		X = X(Ylims,Xlims);
		Y = Y(Ylims,Xlims);
		Z = Z(Ylims,Xlims);
		C = C(Ylims,Xlims);
		ZHclip = find(Z > newlims(6));
		if(~isempty(ZHclip))
			Z(ZHclip) = newlims(6)*ones(size(ZHclip));
		end
		ZLclip = find(Z < newlims(5));
		if(~isempty(ZLclip))
			Z(ZLclip) = newlims(5)*ones(size(ZLclip));
		end
		set(objdata(i).handle,'XData',X,'YData',Y,'ZData',Z,'CData',C);
	else
		X = objdata(i).XD;
		Y = objdata(i).YD;
		Z = objdata(i).ZD;
		OOB = find((X < newlims(1)) |...
					  (X > newlims(2)) |...
					  (Y < newlims(3)) |...
					  (Y > newlims(4)) |...
					  (Z < newlims(5)) |...
					  (Z > newlims(6)));
		Z(OOB) = NaN*ones(size(OOB));
		set(objdata(i).handle,'XData',X,'YData',Y,'ZData',Z);
	end
end

if(~h)
	hold off;
end
axis(newlims);
set(gcf,'pointer','arrow');
set(gcf,'WindowButtonDownFcn',MDDatObjs.ZoomData.Old.WindowButtonDownFcn);
