function track(akcja)
%TRACK	   Show, for 2D plots , co-ordinates of function point,
%	which is mark on it, by  gray color crroslines .
%	TRACK ON	-turns on
%	TRACK OFF	-turns it off
%	TRACK    	-siwtitch between ON or OFF
%
%TRACK	  Wy?wietla na wykresie 2-D wsp??rz?dne punktu funkcji,
%	kt?ry jest zaznaczony  na nim dwiema przecinaj?cymi si?
%	prostopad?ymi do siebie liniami koloru szarego (krzy?).
%
%	TRACK ON  lub  TRACK('ON')   za??cza ?ladowanie punkt?w
%	wykresu  kt?ry by? plot-owany jako ostatni  w  bie??cym
%	uk?adzie wsp??rz?dnych.
%	TRACK OFF lub  TRACK('OFF') wy??cza ?ladowanie usuwaj?c
%	tak?e "krzy?" z uk?adu wsp??rz?dnych.
%	TRACK bez argumentu wej?ciowego powoduje zmian? ststusu
%	mi?dzy ON oraz OFF -jest to polecany spos?b korzystania
%	z funkcji TRACK.
%
%	TRACK mo?e wsp??pracowa? z funkcj?  ZOOM pod warunkiem,
%	?e zostanie wywo?ana po niej.  Wywo?anie  funkcji  ZOOM
%	po funkcji TRACK spowoduje wykasowanie TRACK.
%	
%	UWAGA:	Prawid?owe  warto?ci  wy?wietla dla  aktywnych 
%		wykres?w 2-D na tylko p?aszczy?nie X-Y. Wyniki
%		dla wykres?w 3-D s? zwyk?? fikcj?.
%
%	Zobacz te?(See): PLOT, FPLOT, LINE, ZOOM, WHITEBG.

%	17:58  1999-02-18
%	23:33  1999-03-01
%	All rights reserved.
%	Copyright (c) by Tadeusz GRYSZKA 
%	I wrote this function for my own satisfaction.

figH=get(0,'CurrentFigure');
axH=get(figH,'CurrentAxes');
axsH=findobj(figH,'Type','axes');



if nargin==0,
   if strcmp(get(figH,'WindowButtonMotionFcn'),'track(''xyz'')'),
	track('off');
   else
	track('on');
   end

elseif nargin==1
   if strcmp(akcja,'on')

	figure(figH)

%	figPos=get(figH,'Pos');
%	set(figH,'Pos',figPos);

	h=findobj(figH,'UserData','*');
	set(h,'Visible','off');
	delete(h);	

      for n=1:length(axsH)

	axH=axsH(n);
	axes(axH);

	xlim=get(axH,'xLim');
	xmax=max(xlim);

	ylim=get(axH,'yLim');
	ymax=max(ylim);

	xH=line([xmax xmax], ylim, ...
	'Visible','off',...
	'Color',[.5 .5 .5], ...
	'LineStyle','-', ...
	'UserData','*',...
	'EraseMode','xor');

	txH=text(...
	'Visible','off',...
	'Vertical','bottom', ...
	'Horizontal','center', ...
	'FontSize',10, ...
	'Color',[.5 .5 .5],...
	'String','x',...
	'UserData','*',...
	'Erase','xor',...
	'Pos',[xmax ymax]);

	yH=line(xlim, [ymax ymax], ...
	'Visible','off',...
	'Color',[.5 .5 .5], ...
	'LineStyle','-', ...
	'UserData','*',...
	'EraseMode','xor');

	tyH=text(...
	'Visible','off',...
	'Vertical','middle', ...
	'Horizontal','left', ...
	'FontSize',10, ...
	'Color',[.5 .5 .5], ...
	'String','y', ...
	'UserData','*',...
	'Erase','xor',...
	'Pos',[xmax ymax]);

	set(axH,'UserData',[xH yH txH tyH]);
      end;

	set(...
	findobj(figH,'UserData','*'),...
	'Visible','on');

	set(axsH, ...
	'DrawMode','fast', ...
	'Interruptible','no');

	set(figH, ...
	'Pointer','Crosshair', ...
	'UserData',axH, ...
	'WindowButtonMotionFcn','track(''xyz'')', ...
	'interruptible','no');
%	'Pos',get(figH,'Pos'),...


   elseif strcmp(akcja,'off')
	H=get(figH,'UserData');
	if H~=[]
	   axH=H;
	end;


	H=get(axH,'UserData');
	set(axH,'UserData',[])
	if H==[]
	   return;
	end;
	set(H,'Visible','off');
	delete(H)

	set(figH, ...
	'pointer','arrow', ...
	'Pos',get(figH,'Pos'), ...
	'WindowButtonMotionFcn','');


   elseif strcmp(akcja,'xyz')

	axH=get(figH,'CurrentAxes');
%	if axH~=get(figH,'UserData');
%	   %track('off');
%	   track('on') ;
%	end

	H=get(axH,'UserData');
	if H==[]
	   track('on');
	   return;
	end;
	xH=H(1);
	yH=H(2);
	txH=H(3);
	tyH=H(4);

	xlim=get(axH,'xLim');
	xmax=max(xlim);
	ylim=get(axH,'yLim');
	ymax=max(ylim);

	lnH=findobj(axH,'Type','line');
%	plH=findobj(axH,'Type','line','UserData','*');
	lnH=lnH((lnH~=xH)&(lnH~=yH));

	if lnH==[]
	   track('off')
	   disp('TRACK: Brak wykresu.')
	   return;
	end

	lnH=lnH(1);
	x=get(lnH,'xData');
	y=get(lnH,'yData');

	pkt=get(axH,'CurrentPoint');
	pkt=pkt(1,1);
	n=min(find(x>=pkt));
	m=max(find(x<=pkt));
	if n==[];
	   n=m;
	end;
%	set([xH yH],'Visible','off')
	set(xH,'xData', [x(n) x(n)], 'yData', ylim);
	set(yH,'xData', xlim, 'yData', [y(n) y(n)]);
	set([xH yH],'Visible','on')

	num='%.4g';
%	xpkt=[  'x= '  sprintf(num, x(n)) ';'];
%	ypkt=['  y= '  sprintf(num, y(n)) ';'];
%	set(figH,'Name',[xpkt ypkt]);

	xpkt=sprintf(num, x(n));
	ypkt=['  ' sprintf(num, y(n))];
	set([txH tyH],'Visible','off')
	set(txH,'Position',[x(n) ymax],'String',xpkt)
	set(tyH,'Position',[xmax y(n)],'String',ypkt)
	set([txH tyH],'Visible','on')
   else
	error('TRACK: Nieznana komenda.')
   end

else
   error('TRACK: Za wiele argument?w.')
end

% Copyright by Tadeusz GRYSZKA
% All  rights reserved