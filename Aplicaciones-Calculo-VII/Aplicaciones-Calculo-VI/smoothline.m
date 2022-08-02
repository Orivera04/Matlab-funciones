function smoothline(lh, opt)
% function varargout = smoothline(varargin)
%
%	SYNTAX:
%		smoothline(lh)
%	INPUT:
%		h: handle to the line to be smoothed
%		(opt: paramter used for self invoked calls)
%
% Description:
%	This function is meant to be used for manually smoothing a line of the current axes.
%	Initially it blanches all existing lines and draws a new line in the original color of
%	the line specified by the line handle lh. This new line simply connects the first
%	point of lh with its last point.
%	The user can add additional points by mouse click and the function draws a piecewise
%	polynomial spline line through these points. It is also possible to move the points
%	and watch the influence on the fitted curve. If a point is moved too close to a
%	neighbouring point it will be deleted.
%	By double clicking an existing marker the line lh takes over the xyz-data of the
%	spline curve, the original settings are restored, the spline line is removed and the
%	function gets devoked.
%
% Remark: 
%	this version is expecting a view(0,0) at the current axes and lines where the
%	ordinate is displayed in the z-plane instead of the y-plane. This can simply be
%	changed by replacing the cp(2,3) by cp(1,2) and the z(k.index) by y(k.index) and the
%	spline(x,z) by spline(x,y)...
%
%	EXAMPLE:
% 		>> x=1:20;
% 		>> y=zeros(1,20);
% 		>> z=rand(1,20);
% 		>> lh=line('xdata',x,'ydata',y,'zdata',z);
% 		>> view(0,0)
% 		>> smoothline(lh)
% 		>> 
%		
% Written by Martin Lohrmann
% martin.lohrmann@gmx.de
% 01 February 2005
%
% This function was inspired by the moveplot function written by
% Brandon Kuczenski for Kensington Labs
% brandon_kuczenski@kensingtonlabs.com
% 17 September 2001



switch nargin
case 0
    error('Must Specify a handle to a line object')
case 1
    opt=[];
end

if strcmp(get(gcf,'selectiontype'),'open')
	% on double-click change the tag  for the following switch statement
	set(lh,'tag','smoothlineoff');
else
    if ~isempty(opt) && ~any(opt==[1 2])
        error(['Second argument ''' opt ''' is an unknown command option.'])
    end
end


switch get(lh,'tag')
	case 'smoothlinemove'
		k=get(lh,'userdata');
		switch opt
			case 1	% WindowButtonMotionFcn
				cp=get(gca,'currentpoint');
				x=get(k.ml,'xdata');
				y=get(k.ml,'ydata');
				z=get(k.ml,'zdata');
				xx=get(k.sl,'xdata');
				
				% curser must stay greater or equal lower x limit
				if k.index==1&&cp(1,1)<xx(1)
					cp(1,1)=x(1);
				end
				% curser must stay below or equal upper xlimit
				if k.index==length(x)&&cp(1,1)>xx(end)	% curser must stay below or equal upper xlimit
					cp(1,1)=x(end);
				end
				% the moving marker is deleted if it moves too close to the next marker
				if k.index<length(x)&&(x(k.index+1)-cp(1,1))<0.01*(xx(end)-x(1))
					x(k.index)=[];
					y(k.index)=[];
					z(k.index)=[];
					k.index=k.index;
					cp(1,1)=x(k.index);
					cp(1,2)=y(k.index);
					set(k.sl,'tag','smoothlineclick')
					set(gcf,'windowbuttonmotionfcn',k.winbmfcn,'windowbuttonupfcn',k.winbupfcn,'doublebuffer',k.doublebuffer);
				end
				% the moving marker is deleted if it moves too close to the previous marker
				if k.index>1&&(cp(1,1)-x(k.index-1))<0.01*(xx(end)-x(1))
					x(k.index)=[];
					y(k.index)=[];
					z(k.index)=[];
					k.index=k.index-1;
					cp(1,1)=x(k.index);
					cp(1,2)=y(k.index);
					set(k.sl,'tag','smoothlineclick')
					set(gcf,'windowbuttonmotionfcn',k.winbmfcn,'windowbuttonupfcn',k.winbupfcn,'doublebuffer',k.doublebuffer);
				end
				
				% update marker line
				x(k.index)=cp(1,1);
				y(k.index)=cp(1,2);
				set(k.ml,'xdata',x,'ydata',y,'zdata',z);
				% update spline fit
				pp=spline(x,y);
				yy=ppval(pp,xx);
				set(k.sl,'xdata',xx,'ydata',yy);
			case 2	% WindowButtonUpFcn
				% next step: wait for another click
				set(lh,'tag','smoothlineclick')
				% restore the window functions
				set(gcf,'windowbuttonmotionfcn',k.winbmfcn,'windowbuttonupfcn',k.winbupfcn,'doublebuffer',k.doublebuffer);
		end
	case 'smoothlineoff'
		% restore original settings
		k=get(lh,'userdata');
		set(gcf,'windowbuttondownfcn',k.winbdnfcn,...
			'windowbuttonmotionfcn',k.winbmfcn,...
			'windowbuttonupfcn',k.winbupfcn,...
			'doublebuffer',k.doublebuffer,...
			'selectiontype',k.selectiontype);
		set(gca,'userdata',k.aud,'ylimmode',k.ylm,'buttondownfcn',k.abdfcn);
		for n=1:length(k.line)
			set(k.line(n).lh,'color',k.line(n).lc,'linewidth',k.line(n).lw,'linestyle',k.line(n).ls,'ButtonDownFcn',k.line(n).bdfcn)
		end
		% copy the values of the modified line to the line h
		x=get(k.sl,'xdata');
		y=get(k.sl,'ydata');
		z=get(k.sl,'zdata');
		set(k.h,'xdata',x,'ydata',y,'zdata',z,'tag',k.htag,'userdata',k.hud);
		% delete the modification lines (marker and spline)
		delete([k.ml k.sl])
	case 'smoothlineclick'
		k=get(lh,'userdata');
		k.winbmfcn=get(gcf,'windowbuttonmotionfcn');	% save current window motion function
		k.winbupfcn=get(gcf,'windowbuttonupfcn');		% save current window up function
		k.doublebuffer=get(gcf,'doublebuffer');			% save current doublebuffer setting
		k.selectiontype=get(gcf,'selectiontype');		% save current figure SelectionType
		cp=get(gca,'currentpoint');
		switch opt
			case 1	% ButtonDownFcn for existing marker
				% determine which marker the user clicked on
				x=abs(get(k.ml,'xdata')-cp(1,1));
				y=abs(get(k.ml,'ydata')-cp(1,2));
				d=sqrt(x.^2+y.^2);
				k.index=find(d==min(d));	% store the marker index
			case 2	% ButtonDownFcn setting new marker
				% add the new xyz data
				x=[cp(1,1),get(k.ml,'xdata')];
				y=[cp(1,2),get(k.ml,'ydata')];
				z=[0, get(k.ml,'zdata')];
				% and sort the x
				[x,m,n]=unique(x);
				y=y(m);
				% update marker line
				set(k.ml,'xdata',x,'ydata',y,'zdata',z)
				% store marker index
				k.index=find(x==cp(1,1));
				% update spline fit
				pp=spline(x,y);
				xx=get(k.sl,'xdata');
				yy=ppval(pp,xx);
				set(k.sl,'xdata',xx,'ydata',yy);
		end
		% prepare for WindowMotionFcn
		set(lh,'tag','smoothlinemove','userdata',k);
		set(gcf,'windowbuttonmotionfcn','smoothline(get(gca,''userdata''),1)',...
			'windowbuttonupfcn','smoothline(get(gca,''userdata''),2)',...
			'doublebuffer','on');
	otherwise	% initialize function
		% store original settings in structure
		k.winbdnfcn=get(gcf,'windowbuttondownfcn');	% original WindowButtonDownFcn
		k.abdfcn=get(gca,'buttondownfcn');			% original axes ButtonDownFcn
		k.aud=get(gca,'userdata');					% original axes userdata
		k.ylm=get(gca,'ylimmode');					% original axes YLimMode
		all=findobj(gca,'type','line');	% line handles
		for n=1:length(all)
			k.line(n).lh=all(n);						% line handle
			k.line(n).lc=get(all(n),'color');			% line color
			k.line(n).lw=get(all(n),'linewidth');		% line width
			k.line(n).ls=get(all(n),'linestyle');		% line style
			k.line(n).bdfcn=get(all(n),'buttondownfcn');% line ButtonDownFcn
		end
		k.h=lh;								% handle of original line
		k.htag=get(lh,'tag');				% original tag of line h
		k.hud=get(lh,'userdata');			% original userdata of line h
		k.color=get(lh,'color');			% color for marker and spline lines
		% blanching lines
		for n=1:length(all)
			set(all(n),'color',[0.7 0.7 0.7]+0.3.*k.line(n).lc,'linewidth',0.5,'linestyle','-');
		end
		% set marker line
		x=get(lh,'xdata');x=[x(1) x(end)];
		y=get(lh,'ydata');y=[y(1) y(end)];
		z=repmat(0,size(x,1),size(x,2));
		k.ml=line('xdata',x,'ydata',y,'zdata',z,'color',k.color);
		set(k.ml,'marker','o','markersize',4,'markerfacecolor',k.color,'linestyle','none');
		% set spline line
		pp=spline(x,y);
		xx=get(lh,'xdata');
		yy=ppval(pp,xx);
		zz=repmat(0,size(xx,1),size(xx,2));
		k.sl=line('xdata',xx,'ydata',yy,'zdata',zz,'color',k.color);
		% bring marker line to front, next is spline line, then the rest
		ac=get(gca,'children');
		ac(ac==k.ml|ac==k.sl)=[];
		ac=[k.ml;k.sl;ac(:)];
		set(gca,'children',ac);
		% store h in axes' userdata for evaluation in the Callback commands and define the
		% next step as tagname
		set(k.sl,'tag','smoothlineclick','userdata',k);
		set(gca,'userdata',k.sl,'ylimmode','manual')
		% next step: wait for buttondown functions
		set([gca;k.sl;all(:)],'buttondownfcn','smoothline(get(gca,''userdata''),2)');
		set(k.ml,'buttondownfcn','smoothline(get(gca,''userdata''),1)');
end




