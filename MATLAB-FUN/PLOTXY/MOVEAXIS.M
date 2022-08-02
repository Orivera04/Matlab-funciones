function moveaxis(arg)
%MOVEAXIS  Used to grab and move legends and axes.
%	To use, click and hold down a mouse button while
%	the cursor is near the lower left corner of the
%	axis you want to move. Wait for the cursor to change
%	to a fleur (4 way arrows), then drag the legend or axis
% 	to the desired location and release the mouse button.
%
%	To enable, set the figure window's WINDOWBUTTONDOWNFCN
%	property to 'moveaxis'. For example,
%
%	         set(gcf,'WindowButtonDownFcn','moveaxis')

%	10/5/93  D.Thomas
%	Copyright (c) 1984-94 by The MathWorks, Inc.



global OLDCA DELTA HL FIGUTS;
if nargin==0,
st=get(gcf,'SelectionType');
if (strcmp(st,'normal'))
		moveaxis(1);
end
elseif arg==1,
	FIGUTS = get(gcf,'units');
	set(gcf,'pointer','fleur');
	if strcmp(FIGUTS,'normalized'),
		pnt = get(gcf,'currentpoint');
		set(gcf,'units','pixels');	
		pos = get(gcf,'position');
		pnt = [pnt(1) * pos(3) pnt(2) * pos(4)];
	else,
		set(gcf,'units','pixels');
		pnt=get(gcf,'currentpoint');
	end
	Kids=get(gcf,'children');
	[n,tmp]=size(Kids);
	mn=1e20;
	mi=1;
	for i=1:n,
		if strcmp(get(Kids(i),'type'),'axes'),
			units=get(Kids(i),'units');
			set(Kids(i),'units','pixels')
			cap=get(Kids(i),'position');
			if sum((pnt-cap(1:2)).^2)<mn,
				mn=sum((pnt-cap(1:2)).^2);
				mi=i;
				DELTA=cap(1:2)-pnt;
			end
			set(Kids(i),'units',units);
		end
	end
	tmp=get(Kids(mi),'userdata');
	OLDCA=gca;	
	if (~isempty(tmp)),
		if tmp(1)==1.1;	% Magic number for legends
			set(Kids(mi),'userdata',[tmp(1:6),1]);
			OLDCA=tmp(2);
		end
	end
	set(gcf,'currentobject',Kids(mi));			
	HL=[Kids(mi) abs(get(Kids(mi),'units'))];
	set(Kids(mi),'units','pixels');
	set(gcf,'windowbuttonmotionfcn','moveaxis(2)')
 	set(gcf,'windowbuttonupfcn','moveaxis(3)');
elseif arg==2,
	pos=get(get(gcf,'currentobject'),'position');
	set(get(gcf,'currentobject'),'units','pixels','drawmode','fast',...
	'position',[get(gcf,'currentpoint')+DELTA pos(3:4)]);
elseif arg==3,
 	set(gcf,'WindowButtonMotionfcn','', ...
	    'pointer','arrow','currentaxes',OLDCA, ...
		'windowbuttonupfcn','');
	set(HL(1),'units',setstr(HL(2:length(HL))));
	set(gcf,'units',FIGUTS);
end



