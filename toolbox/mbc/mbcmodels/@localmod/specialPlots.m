function specialPlots(L,plotname,axhand,X,Y)
% function pH= specialPlots(L,plotname,ax)
%
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:41 $
hFig = get(axhand,'parent');
set(hFig,'currentaxes',axhand);

mv_rotate3d(axhand,'off');

mbH= MBrowser;
p= mbH.CurrentNode;
View= mbH.GetViewData;

SNo= View.SweepPos;


% Loop over the number of plots
switch lower(plotname)
case 'contour'
	set(axhand,'View',[0 90])
	i_contour(L,p,SNo,axhand);
case 'surface'
	i_surface(L,p,SNo,axhand);
end


function i_contour(L,p,SNo,axhand)

[X,Y,DataOK]= FitData(p.info,SNo);

xd= double(X(DataOK));
yd= double(Y(DataOK));

[LB,UB]= range(L);

zd= EvalModel(L,xd);

[XI,YI,ZI]= griddata(xd(:,1),xd(:,2),yd,linspace(LB(1),UB(1),100),linspace(LB(2),UB(2),100)');
pts= isfinite(ZI);
if any(pts(:))
	% evaluate model at these points
	ZI(pts)= EvalModel(L,[XI(pts),YI(pts)]);
	hFig = get(axhand,'parent');
	set(0,'currentfigure',hFig);
	set(hFig,'currentaxes',axhand,'handlevis','on');
	
	[c,h]= contourf(XI,YI,ZI,10);
	clabel(c,h);
	set(hFig,'handlevisibility','callback');
	
	line('parent',axhand,...
		'xdata',xd(:,1),'ydata',xd(:,2),...
		'zdata',yd,...
		'Marker','.','MarkerSize',15,...
		'LineStyle','none')
else
	delete(get(axhand,'children'));
end


labs= get(L,'symbol');

set(get(axhand,'xlabel'),'string',labs{1},'interpreter','none');
set(get(axhand,'ylabel'),'string',labs{2},'interpreter','none');
%set(get(axhand,'title'),'string',sprintf('Test %2g',SNo),'FontWeight','bold');


function i_surface(L,p,SNo,axhand)

[X,Y,DataOK]= FitData(p.info,SNo);

xd= double(X(DataOK));
yd= double(Y(DataOK));

[LB,UB]= range(L);

[XI,YI,ZI]= griddata(xd(:,1),xd(:,2),yd,linspace(LB(1),UB(1),51),linspace(LB(2),UB(2),51)');
pts= isfinite(ZI);
% evaluate model at these points
if any(pts(:))
	ZI(pts)= EvalModel(L,[XI(pts),YI(pts)]);
	
	hFig = get(axhand,'parent');
	set(0,'currentfigure',hFig);
	set(hFig,'currentaxes',axhand,'handlevis','on');
	
	[az,ez]= view(axhand);
	hs=surf(XI,YI,ZI,ZI,...
		'parent',axhand,...
		'FaceColor','interp','EdgeColor','none',...
		'facealpha',0.7,...                     % set alpha so copy plot at least will be transparent
		'FaceLighting','ph','BackFaceLighting','reverselit');
	
	if az== 0 & ez==90
		set(axhand,'View',[-37.5,30])
	end
	hL=findobj(axhand,'type','light');
	if isempty(hL)	
		hL=light('parent',axhand,'col','w','style','local');
	end
	camlight(hL,'headlight') 
	set(hFig,'handlevis','call');
	
	mv_rotate3d(axhand,'on');
	
	line('parent',axhand,...
		'xdata',xd(:,1),'ydata',xd(:,2),...
		'zdata',yd,...
		'Marker','.','MarkerSize',20,...
		'LineStyle','none')
	X= zeros(3,size(xd,1));
	X(3,:)= NaN;
	X(1:2,:)= xd(:,[1 1])';
	Y=X;
	Y(1:2,:)= xd(:,[2 2])';
	Z=X';
	[Z(:,1),Z(:,2)]=cicalc(L,xd,[],0.95,0);
	Z= Z';
	line('parent',axhand,...
		'xdata',X(:),'ydata',Y(:),...
		'zdata',Z(:),...
		'Marker','none',...
		'LineStyle','-')
	
else
	delete(get(axhand,'children'));
end


labs= get(L,'symbol');
yi= yinfo(L);
set(get(axhand,'xlabel'),'string',labs{1},'interpreter','none');
set(get(axhand,'ylabel'),'string',labs{2},'interpreter','none');
set(get(axhand,'zlabel'),'string',yi.Name,'interpreter','none');
%set(get(axhand,'title'),'string',sprintf('Test %2g',SNo),'FontWeight','bold');
