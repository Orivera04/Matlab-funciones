function View=View(mdev, mbH, View)
% VIEW Update current view
%
%  view(TP, mbH)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 08:05:23 $



% Create 11/4/2001


hFig=double(mbH.Figure);
p=address(mdev);

SNo=View.SweepPos;

TabNo= get(View.ChildTab,'currentcard');

%% set the update button on the toolbar
updateBut=find(View.toolbarBtns ,'tag','update');
if View.Update
    set(updateBut,'enable','on');
	 set(View.menus.model(3),'enable','on');
	 wasTS= ~isempty(BestModel(mdev)); 
    p.BestModel(0);
    mbH.doDrawTree(p);
	 mbH.doDrawIcons;
	 if wasTS
		 mbH.listview;
		 mbH.doDrawTree(children(mdev));
	 end
	 if ~isempty(findobj(get(0,'children'),'flat','tag','RMSE Explorer'))
		 rmse_explorer(mdev);
	 end
else
    set(updateBut,'enable','off');
	 set(View.menus.model(3),'enable','off');
end

%------------------------------
% Page 1 - Local Response + local stats on monitor plots
%------------------------------
OK= local_response(mdev,hFig,View);
%------------------------------
% Page 2 - Monitor Plot
%------------------------------
% Get the testplan
TP = address(mdevtestplan(mdev));
mv_MonitorPlots('update',hFig,TP,SNo,p);

setup = findobj(hFig,'type','uimenu','tag','setupMonitorplots');
if TabNo==2
    set(setup,'enable','on');
else
    set(setup,'enable','off');
end


TS= BestModel(mdev);
st= children(mdev,'status');
if ~isempty(TS) | hasBest(mdev) | (numSubModels(mdev)==1 & all([st{:}]));
	set(View.menus.model(4),'enable','on')
	set(View.toolbarBtns(3),'enable','on');
   if any([st{:}]==2)
      % assign best 
    	set(View.menus.model(end),'enable','on')
   else
      set(View.menus.model(end),'enable','off')
   end
else
   set(View.menus.model(end),'enable','off')
	set(View.menus.model(4),'enable','off')
	set(View.toolbarBtns(3),'enable','off');
end

