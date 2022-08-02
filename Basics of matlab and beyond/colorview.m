function hfig=colorview(arg,himage,datamin,datamax,dismissMode) 
%
% hfig=colorview(haxes,himage,datamin,datamax,dismissMode)
% hfig=colorview(haxes,himage,datamin,datamax)
% colorview('refresh',himage,hcolorfig)
%
% COLORVIEW is designed to be used by a parent figure window which has
% an image object displayed and needs to give the user interactive
% control over the colormap and other color features. If the parent
% object has a pseudocolor display, then it show use PCOLORVIEW instead
% to achieve a similar functionality.
% COLORVIEW takes a handle to an axes object as its first argument and
% displays another figure window showing the colormap and color axis
% active in the window containing the axes.  Facilities are provided to
% adjust, or change entirly, the colormap and install it in the first
% window.  The first two calling modes are used to initialize a
% COLORVIEW object and differ in that one always assumes the the figure
% will simply become invisible when dismissed while the other offer the
% ability to kill the figure when dismissed. Both return the handle of
% the color figure so that the parent window can keep track of it. The
% third mode of calling is intended to be used by the parent window
% when the handle of the image object has changed (e.g. it has been
% redrawn) and an existing color figure needs to be notified. (This is
% only intended for situations in which the data has not changed. If
% the data has changed then the color fibure should be closed and
% rebuilt)
%	haxes = handle to an axes object
%	himage = handle of the image object in the parent figure
%	datamin = true minumum of the data being displayed in the axes
%	datamax = true maximum of the data being displayed in the axes 
%	dismissMode = 1 ... dismiss button sets figure's visible property
%						to 'off'
%		    = 0 ... dismiss button kills figure window
%	********** default = 1 ************
%	hcolorfig = handle of the color figure
%	hfig = handle of the color figure window
%
% Example:
%
% z = peaks;
% h = imagesc(z);
% colorview(gca,h,min(min(z)),max(max(z)));
% 

% G.F. Margrave, October 1993
% Chevron Canada Resources, vgmar@chevron.com

% Graphical interface modified 28/11/94 by A. Knight to improve location
% of buttons and general appearance, etc.

% user data assignments:
% figure = all of the graphics handles
%         [hcmaxLabel,hcmax,hcminLabel,hcmin,hbrighten,hdarken,
%         hinstall,hdismiss,hgrid,hax,hfigure,hmaps, hmapsLabel]
% axes = z vaues of fake grid
% hcmaxLabel = handle of the image plot
% hcmax = none
% hcminLabel = none
% hcmin = none
% hbrighten = none
% hdarken = none
% hinstall = none
% hauto = none
% hdismiss = dismissMode
% hmaps = original colormap
% hmapsLabel = none

% determine the type of argument passed
if( isstr(arg) )
	action = arg;
else
	haxes=arg;
	action = 'initialize';
end

if( strcmp(action,'initialize') )
if( nargin < 5 ) dismissMode = 1; end
% get the figure window and the colormap
	hfigure = get(haxes,'Parent');
	clrmap = get(hfigure,'ColorMap'); 
% get the color axis limits
	clim = get(haxes,'Clim');
% open a new figure window
	pos=get(hfigure,'Position');
	units = get(hfigure,'Units');
	figwidth = 175;% in pixels
	figheight = 350;
	BackgroundColour = [.65 .75 .65];
 	hfig=figure(...
	    'Position',[pos(1)-figwidth,pos(2),figwidth,figheight],...
	    'color',[.7 .7 .7],...
	    'ColorMap',clrmap,...
	    'Units',units,...
	    'Name','Colour Adjust');
% make some data to show the colors
	x=[1 2 3 4 5];
	[m,n]=size(colormap);
 imagedata = get(himage,'cdata');
 ind=~isnan(imagedata);
 immin = floor(min(min(imagedata(ind))));
 immax = ceil(max(max(imagedata(ind))));
 z = (immax:-1.:immin)';
	y=linspace(datamax,datamin,length(z));
	y=y';
	z=z*ones(1,5);
% make some controls
	sep = 2;
	width = 80;
	height = 20;
	
	xnow= 2*sep;
	ynow = 0.98*figheight-height;
	hcmaxLabel = uicontrol('Style','Text','String','Color Max:',...
	    'Position',[xnow,ynow,width,height],'userdata',himage);
	
	xnow = xnow+width+sep;
	maxsetting = m-(m-1)*(immax-m)/(immax-immin);
	hcmax = uicontrol('Style','slider','Position',[xnow,ynow,...
		width,height],'Min',1,'Max',m,...
	    'Backgroundcolor',BackgroundColour,...
	    'Value',maxsetting,'Callback','colorview(''cmax'')');
	    
	ynow=ynow-sep-height;
	xnow = 2*sep;
	hcminLabel = uicontrol('Style','Text','String','Color Min:',...
		'Position',[xnow,ynow,width,height]);
	    
	xnow = xnow+width+sep;
 minsetting = 1+(m-1)*(1-immin)/(immax-immin);
	hcmin = uicontrol('Style','slider','Position',[xnow,ynow,...
		width,height],'Min',1,'Max',m,...
	    'Backgroundcolor',BackgroundColour,...
		'Value',minsetting,'Callback','colorview(''cmin'')');

	ynow=ynow-sep-height;
	xnow = 2*sep + width + sep;
	hauto=uicontrol('Style','pushbutton','String','Auto Scale',...
		'BackgroundColor',BackgroundColour,...
		'Position',[xnow,ynow,width,height],'Callback',...
		'colorview(''autoscale'')');
	    
ynow=ynow-4*sep-height;
xnow=2*sep;
hmapsLabel = uicontrol('style','text','string','Color Map:',...
  'Position',[xnow,ynow,width,height]);

xnow = xnow+width+sep;
 hmaps = uicontrol('style','popupmenu','string',...
  'original|hsv|gray|hot|cool|bone|copper|pink|jet|alpine',...
  'userdata',clrmap,'position',[xnow,ynow,width,height],...
  'BackgroundColor',BackgroundColour,...
  'callback','colorview(''maps'')');

ynow=ynow-4*sep-height;
	xnow = 2*sep+width+sep;
	hbrighten=uicontrol('Style','pushbutton','String','Brighten',...
	    'BackgroundColor',BackgroundColour,...
		'Position',[xnow,ynow,width,height],'Callback',...
		'colorview(''brighten'')');
	    
	xnow=2*sep;
	hdarken=uicontrol('Style','pushbutton','String','Darken',...
	    'BackgroundColor',BackgroundColour,...
		'Position',[xnow,ynow,width,height],'Callback',...
		'colorview(''darken'')');
	    
	ynow=ynow-4*sep-1.5*height;
	xnow = 2*sep;
	hinstall=uicontrol('Style','pushbutton','String','Apply',...
	    'BackgroundColor',BackgroundColour,...
		'Position',[xnow,ynow,2*width+sep,1.5*height],'Callback',...
		'colorview(''install'')');
	    
	ynow=2*sep;
	xnow = 2*sep + width/2;
	hdismiss=uicontrol('Style','pushbutton','String','Dismiss',...
		'BackgroundColor',BackgroundColour,...
		'Position',[xnow,ynow,width,height],'Callback',...
		'colorview(''dismiss'')','userdata',dismissMode);
	
% plot a grid
	hgrid=image(x,y,z);
	hax=get(hgrid,'Parent');
	%set(hax,'Units','pixels');
 	ytick = linspace(min(y),max(y),10);
 	fact = floor(log10(ytick(10)-ytick(1)));
 	fact = 10^(fact-2);
	ytick = fact*floor(ytick/fact);
	set(hax,'XTick',[],'AspectRatio',[.25,NaN],'ytick',ytick,...
		'Position',[0,.1,1,.4],'Clim',clim,'userdata',z,...
		'TickDir','out');
		%'Position',[5,5,figwidth,figheight-ynow]);

% store all of the graphics handles in the figure
	set(gcf,'UserData',[hcmaxLabel,hcmax,hcminLabel,hcmin,...
		hbrighten,hdarken,hinstall,hdismiss,hgrid,hax,hfigure,...
  hmaps, hmapsLabel]);
  return;
end

if( strcmp(action,'cmin')|strcmp(action,'cmax') )
% get the handles
	h=get(gcf,'UserData');
	hcmin=h(4);
 hcmax=h(2);
% get the new min & max from the sliders
	valmin = get(hcmin,'Value');
 valmax = get(hcmax,'value');

%get the colormap
clrmap = get(gcf,'colormap');
n=length(clrmap);

% get the data and scale it
 hgrid = h(9);
 z = get(hgrid,'cdata');
 zmax=max(z(:));zmin=min(z(:));
 z = (n-1)*(z-zmin)/(zmax-zmin)+1;
 z = (n-1)*(z-valmin)/(valmax-valmin)+1;

% reinstall the data
	set(hgrid,'cdata',z);
	return;
end

if( strcmp(action,'brighten') )
	brighten(.5);
	return;
end

if( strcmp(action,'darken') )
	brighten(-.5);
	return;
end

if( strcmp(action,'install') )
	h=get(gcf,'UserData');
% get the figure
	hfigure=h(11);
% get the image handle
 himage = get(h(1),'userdata');
% get the axes
	haxes=get(hfigure,'CurrentAxes'); %axes of the image
	hax=h(10);% axes of the fake grid
% get the image data
 imagedata = get(himage,'cdata');
% get the new min & max from the sliders
	hcmin=h(4);
 hcmax=h(2);
	valmin = get(hcmin,'Value');
 valmax = get(hcmax,'value');
 % get the colormap from the fake grid
 clrmap = get(gcf,'colormap');
% rescale the image data
 n=length(clrmap);
% scale the data into the range of the colormap
 ind=~isnan(imagedata);
 dmax=max(max(imagedata(ind)));
 dmin=min(min(imagedata(ind)));
 imagedata = (n-1)*(imagedata-dmin)/(dmax-dmin)+1;
% scale data into the range determined by the sliders
 imagedata = (n-1)*(imagedata-valmin)/(valmax-valmin)+1;
% install the image data
 set(himage,'cdata',imagedata);
% install the colormap
	set(hfigure,'ColorMap',clrmap);

	return;
end

if( strcmp(action,'autoscale') )
	h=get(gcf,'UserData');
% get the sliders and set them to maximum
 hcmin = h(4);
 hcmax= h(2);
 val = get(hcmin,'min');
 set(hcmin,'value',val);
 val = get(hcmax,'max');
 set(hcmax,'value',val);

% call the slider refresh
 colorview('cmin');

 % install
 % colorview('install');
	return;
end

if( strcmp(action,'dismiss') )
	h = get(gcf,'userdata');
	hdismiss = h(8);
	dismissMode = get(hdismiss,'userdata');
	if( dismissMode )
		set(gcf,'visible','off');
	else
		close(gcf);
	end
	return;
end	

if( strcmp(action,'maps') )
% order of maps in popup is:
%'original|hsv|gray|hot|cool|bone|copper|pink|jet|alpine'
	h=get(gcf,'UserData');
	hmaps=h(12);
 flag = get( hmaps,'value');
 if( flag == 1) % original colormap
   clrmap = get(hmaps,'userdata');
   colormap(clrmap);
 elseif( flag == 2) % hsv colormap
   colormap(hsv);
 elseif( flag == 3) % gray
   colormap(gray);
 elseif( flag == 4 ) % hot
   colormap(hot);
 elseif( flag == 5) % cool
   colormap(cool);
 elseif( flag == 6) % bone
   colormap( bone );
 elseif( flag == 7) % copper
   colormap(copper);
 elseif( flag== 8 ) % pink
   colormap(pink);
 elseif( flag == 9) % jet
   colormap(jet);
% the following is ineffective because contrast needs the actual amplitude
% distribution of the data in the parent window, not the fake data
% created here
% elseif( flag == 10) % contrast
%   z = get(gca, 'userdata');
%  colormap(contrast(z));
 end
 return;
end

% refresh is called by the parent display if the image has changed in order to
% give the colorfigure the new image handle
if( strcmp(action,'refresh') )
	hcolorfig = datamin;
	h = get(hcolorfig, 'userdata');
	hcmaxLabel = h(1);
	set(hcmaxLabel,'userdata',himage);
	return;
end
	

