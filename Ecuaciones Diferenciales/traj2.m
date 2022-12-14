function traj2(action)
global AxHndl FigNum AA
if nargin<1
	action='initialize';
end
if strcmp(action,'initialize')
	home
	AA= input('Enter a 2x2 matrix in form [a,b;c,d] --> ');
	FigNum=figure(gcf);
	clf
	set(FigNum,...
		'units','normalized',...
		'position',[.1 .1 .8 .8],...
		'Name','Dynamical Systems',...
		'NumberTitle','off',...
		'WindowButtonDownFcn','traj2(''gotraj'')');
	AxHndl=axes(...
		'xlim',[-10 10],...
		'ylim',[-10,10],...
		'xtick',-10:10,...
		'ytick',-10:10,...
		'units','normalized',...
		'position',[.1 .1 .7 .8]);
	xax=line([-10 10],[0 0],'color','black');
	yax=line([0 0],[-10 10],'color','black');
	grid
	axhndl2=axes(...
		'units','normalized',...
		'position',[.85,.7,.1,.2],...
		'visible','off',...
		'xlim',[-1 1],...
		'ylim',[0 1]);
	y=[0 .1 .2 .4 .8];
	x=zeros(size(y));
	line(x,y,...
		'linestyle','o',...
		'color','b');
	line(x,y,...
		'linestyle','-',...
		'color','b');
	textfwd=uicontrol(...
		'style','text',...
		'units','normalized',...
		'position',[.85 .6 .1 .05],...
		'string','fwd',...
		'ForegroundColor','b');
	axhndl3=axes(...
		'units','normalized',...
		'position',[.85,.3,.1,.2],...
		'visible','off',...
		'xlim',[-1 1],...
		'ylim',[0 1]);
	y=[0 .1 .2 .4 .8];
	x=zeros(size(y));
	line(x,y,...
		'linestyle','x',...
		'color','r');
	line(x,y,...
		'linestyle','-',...
		'color','r');
	textbwd=uicontrol(...
		'style','text',...
		'units','normalized',...
		'position',[.85 .2 .1 .05],...
		'string','bwd',...
		'ForegroundColor','r');
	qbut=uicontrol(...
		'style','pushbutton',...
		'string','Quit',...
		'units','normalized',...
		'position',[.85 .05 .1 .05],...
		'callback','traj2(''quit'')');
	figure(FigNum);
	axes(AxHndl)
elseif strcmp(action,'gotraj')
	N=20;
	points=zeros(2,N);
	figure(FigNum);
	axes(AxHndl);
	p=get(gca,'CurrentPoint');
	x=p(1,1);y=p(1,2);
	points(:,1)=[x,y]';
	for k=2:N
		points(:,k)=AA*points(:,k-1);
	end
	fwdpt=line(points(1,:),points(2,:),...
		'linestyle','o',...
		'color','b',...
		'erasemode','background',...
		'clipping','on');	
	fwdseg=line(points(1,:),points(2,:),...
		'linestyle','-',...
		'color','b',...
		'erasemode','background',...
		'clipping','on');	
	for k=2:N
		points(:,k)=inv(AA)*points(:,k-1);
	end
	bwdpt=line(points(1,:),points(2,:),...
		'linestyle','x',...
		'color','r',...
		'erasemode','background',...
		'clipping','on');	
	bwdseg=line(points(1,:),points(2,:),...
		'linestyle','-',...
		'color','r',...
		'erasemode','background',...
		'clipping','on');
elseif strcmp(action,'quit')
	close(FigNum)
end
