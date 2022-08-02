function mv_rubber_box(action,varargin)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:33:41 $

%   IHN: Doesn't ask if no points selected
%   IHN: Turn off button down function at end
% AKK store all userdata in the current axes.
% AKK when outliers are confirmed, pass over the index to addoutliers
% AKK when we exit from the function pass over the index to a cell array
% 			stored in the View structure in the userdata of the main tree.

if nargin<1
   action='start';
end

oL= OutlierLine(modeldev);
ud= get(oL,'userdata');
hand= ud.g.parent;
if isempty(hand)
   hand=gcf;
end
ah=get(hand,'currentaxes');

switch action
case 'start'
   set(hand,'windowbuttondownfcn',[mfilename,'(''buttndwnfcn'')']);
   
   

case 'buttndwnfcn'
   set(hand,'windowbuttondownfcn','');
   mv_rubber_box('point');
   

case 'point'
   if ~isfield(ud,'rubber')
      ud.rubber=[];
   end
   % prepare axes
   ud.savedstatus.xlimmode=get(ah,'xlimmode');
   ud.savedstatus.ylimmode=get(ah,'ylimmode');
   set(ah,'xlimmode','manual','ylimmode','manual');
   
   SweepLines= findobj(ah,'Type','line','Tag','main line');
   if isempty(SweepLines)
      return
   end
   slxdata= get(SweepLines(1),'xdata');
   set(hand,'windowbuttonupfcn',[mfilename,'(''clean'')']);
   cp=get(ah,'currentpoint');
   point=cp(1,1:2);
   xdata=zeros(1,5);
   ydata=zeros(1,5);
   xdata(:)=point(1);
   ydata(:)=point(2);
   
   boxl=line('Parent',ah,...
      'LineStyle',':',...
      'XData',xdata,...
      'YData',ydata,...
      'color','r',...
      'tag','box');
   
   BD=line('Parent',ah,...
      'linestyle','none',...
      'marker','o',...
      'color',[1 0 0],...
      'Xdata',NaN,...
      'Ydata',NaN,...
      'LineWidth',2,...
      'markersize',12);
   
   
   ud.point=point;
   ud.rubber.xdata=xdata;
   ud.rubber.ydata=ydata;
   ud.rubber.main_line=SweepLines(1);
   ud.rubber.box=  boxl;
   ud.rubber.BD=BD;
   ud.rubber.BD_indx= false(size(slxdata));
   
   set(hand,'WindowButtonMotionFcn',[mfilename,'(''motion'')']);
   set(oL,'UserData',ud);
   
case 'motion'
   set(hand,'WindowButtonUpFcn',[mfilename,'(''clean'')'])
   cp=get(ah,'currentpoint');
   point=cp(1,1:2);
   box=ud.rubber.box;
   xdata=ud.rubber.xdata;
   ydata=ud.rubber.ydata;
   
   xdata([2,3])=point(1);
   ydata([3,4])=point(2);
   i_highlight(xdata,ydata);
      
   set(box,'xdata',xdata,'ydata',ydata);
   drawnow
   
case 'clean'
   set(hand,'WindowButtonUpFcn','');
   set(hand,'WindowButtonMotionFcn','');
   set(hand,'windowbuttondownfcn','');
   % restore axes limits mode
   set(ah,ud.savedstatus);
   % delete the red box...
   delete(ud.rubber.box);
   % update the x and ydata in the outlier line.
   olxdata= get(oL,'xdata');
   BDxdata= get(ud.rubber.BD,'xdata');
   olydata= get(oL,'ydata');
   BDydata=get(ud.rubber.BD,'ydata');
   xdata= [olxdata(:);BDxdata(:)];
   ydata= [olydata(:);BDydata(:)];
   ud.olIndex= union(ud.olIndex,find(ud.rubber.BD_indx));
   set(oL,'userdata',ud,'xdata',xdata,'ydata',ydata);
   if strcmp(get(ah,'tag'),'MonitorAxes')
      mv_MonitorPlots('plotoutliers',hand);
   end
	% clean up the rubber band line.
   set(ud.rubber.BD,'xdata',NaN,'ydata',NaN);
end


function i_highlight(xcoords,ycoords)
oL= OutlierLine(modeldev);
ud= get(oL,'userdata');
lh=ud.rubber.main_line;
xdata=get(lh,'xdata');
ydata=get(lh,'ydata');
if iscell(xdata)
   xdata=xdata{end};
   ydata=ydata{end};
end

xindx=xdata>min(xcoords)&xdata<max(xcoords);
yindx=ydata>min(ycoords)&ydata<max(ycoords);
indx=xindx&yindx;
if ~all(ud.rubber.BD_indx==indx)
   ud.rubber.BD_indx=indx;
   bd_hnd=ud.rubber.BD;
   
   set(bd_hnd,'Xdata',xdata(indx),...
      'Ydata',ydata(indx));
   set(oL,'UserData',ud);
end
