function k = menu(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,...
            s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,s31,s32);
%MENU	Generate a menu of choices for user input.
%	K = MENU('Choose a color','Red','Blue','Green') displays on
%	the screen:
%
%	----- Choose a color -----
%
%	   1) Red
%	   2) Blue
%	   3) Green
%
%	   Select a menu number: 
%
%	The number entered by the user in response to the prompt is
%	returned.  On machines that support it, the local menu system
%	is used.  The maximum number of menu items is 32.
%
%	See also UIMENU.

%	J.N. Little 4-21-87, revised 4-13-92 by LS.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

c = computer;
display = 1;
PC = strcmp(c(1:2),'PC');
if ~strcmp(c(1:2),'PC') & ~strcmp(c(1:2),'MA')
% might be unix or VMS
	if isunix
		display = length(getenv('DISPLAY')) > 0;
	else
		display = length(getenv('DECW$DISPLAY')) > 0;
	end
end
if ~display
	while 1,
		disp(' ')
		disp(['----- ',s0,' -----'])
		disp(' ')
		for n=1:(nargin-1)
		    disp(['      ',int2str(n),') ',eval(['s',int2str(n)])])
		end
		disp(' ')
		k = input('Select a menu number: ');
		if isempty(k), k = -1; end;
		if (k < 1) | (k > nargin - 1) | (~isreal(k)) | (isnan(k)) | isinf(k),
			disp(' ')
			disp('Selection out of range. Try again.')
		else
			return
		end
	end
end

kids = get(0,'Children');
if ~isempty(kids)
	otherfig = gcf;
	M=get(otherfig,'Colormap');
else
	M=get(0,'DefaultFigureColormap');
end
global MENU_VARIABLE;
MENU_VARIABLE = 0;
xedge = 30;
yedge = 35;
ybord = 30;
width = 30;
avwidth = 7; % actually 6.8886 +/- 0.4887
height = 30;
imax = 1;
maxlen = length(s0);
for i = 1:nargin-1
    mx = length(eval(['s',int2str(i)]));
    if mx > maxlen
       maxlen = mx;
       imax = i;
    end
end
twidth = 1.2*maxlen*avwidth;
% now figure out total dimensions needed so things can get placed in pixels
mwwidth = twidth + width + 2*xedge;
mwheight = (nargin+1)*yedge;
ss = get(0,'ScreenSize');
swidth = ss(3); sheight = ss(4);
%left = (swidth-mwwidth)/2;
left = 20;
bottom = sheight-mwheight-ybord;
rect = [left bottom mwwidth mwheight];
fig = figure('Position',rect,'number','off','name',' ','resize','off','Colormap',M);
set(gca,'Position',[0 0 1 1]); axis off;
% Place title
t = text(mwwidth/2,mwheight-yedge/2,s0,'Horizontal','center','Vertical','top','units','pixels');
set(t,'Color','white');
for ii=(nargin-1):-1:1
    i = nargin - ii;
    h1 = uicontrol('position',[xedge  (i-.5)*yedge width+twidth height]);
    set(h1,'callback',['global MENU_VARIABLE,MENU_VARIABLE = ',int2str(ii),';']);
    set(h1,'string',['  ', eval(['s',int2str(ii)])])
    set(h1,'HorizontalAlignment','left');
% left justify string inside button
end
while MENU_VARIABLE == 0
	if PC
		waitforbuttonpress;
	else
		drawnow;
	end
end
k = MENU_VARIABLE;
delete(fig)
if ~isempty(kids)
	set(0,'CurrentFigure',otherfig);
end
