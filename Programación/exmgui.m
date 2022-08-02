function exmgui
%EXMGUI  Master GUI for "Experiments with MATLAB".
%  EXMGUI provides an interface to nineteen of the graphical demonstrations
%  from "Experiments with MATLAB".  Click on any graphic to access
%  the underlying function.
%     fern       biorythm   clockex    lifex      rabbits
%     pagerank   wiggle     t_puzzle   tictactoe  backslash
%     predprey   mandelbrot durerperm  waterwave  expgui
%     sudoku     orbits     morse_gui  pianoex    (help)

close
set(gcf,'numbertitle','off','menubar','none','name','EXM GUI', ...
   'inverthardcopy','off','color','white')
funs = cell(24,1);
for k = 1:24
   if k <= 19 
      p = rem(k-1,5);
      q = (16-k+p)/5;
      axk = [p/5 q/4 1/5 1/4];
   else
      axk = [4/5 (24-k)/20 1/5 1/20];
   end
   ax = axes('pos',axk);
   switch k
      case  1, xfern; f = @xfernf; s = 'fern';
      case  2, xbiorhythm; f = @()biorhythm(now-7670); s = 'biorhythm';
      case  3, xclock; f = @clockex; s = 'clockex';
      case  4, xlifex; f = @lifexf; s = 'lifex';
      case  5, xrabbits; f = @rabbits; s = 'rabbits';
      case  6, miniweb; f = @pagerankf; s = 'pagerank';
      case  7, xhouse; f = @wigglehouse; s = 'wiggle';
      case  8, xtpuzzle; f = @t_puzzle; s = 't\_puzzle';
      case  9, xtictactoe; f = @tictactoe; s = 'tictactoe';
      case 10, xbackslash; f = @backslashf; s = 'backslash';
      case 11, xpredprey; f = @predprey; s = 'predprey';
      case 12, xmandelbrot; f = @mandelbrot; s = 'mandelbrot';
      case 13, xdurerperm; f = @durerperm; s = 'durerperm';
      case 14, xwaterwave; f = @waterwave; s = 'waterwave'; 
      case 15, xexpgui; f = @expgui; s = 'expgui';
      case 16, xsudoku; f = @sudoku; s = 'sudoku';
      case 17, xorbits; f = @orbits; s = 'orbits'; 
      case 18, xmorse; f = @morse_gui; s = 'morse';
      case 19, xpianoex; f = @pianoex; s = 'pianoex';
      case 20, f = @exmlogo; text(.1,.4,'exmlogo'), box on
      case 21, f = @helpwin_exm; text(.1,.4,'helpwin exm'), box on
      case 22, f = @helpwin_exmgui; text(.1,.4,'helpwin exmgui'), box on
      case 23, f = @xclose; text(.1,.4,'close'), box on
      case 24, f = @xnothere; text(.1,.4,'      '), box on
   end
   set(ax,'xtick',[],'ytick',[],'ztick',[]);
   if k <= 19 
      axes('pos',axk)
      axis xy off
      text(.5-.025*length(s),.075,s)
   end
   funs{k} = f;
   drawnow
end
wuf = ['pq=get(gcf,''currentpoint''); p=pq(1); q=pq(2);' ...
       'if p<.01 & q>.99, k=25; elseif p>.75 & q<.25, k=floor(25-20*q);'...
       'else k=16+floor(5*p)-5*floor(4*q); end,' ...
       'funs=get(gcf,''userdata''); if k < 24, figure, end, f=funs{k}; f();'];
set(gcf,'units','norm','userdata',funs,'windowbuttonupfcn',wuf);

% --------------------------------

function xbiorhythm
t0 = fix(now-7670);
t1 = fix(now);
t = (t1-28):1:(t1+28);
y = 100*[sin(2*pi*(t-t0)/23)
         sin(2*pi*(t-t0)/28)
         sin(2*pi*(t-t0)/33)];
plot(t,y)
line([t1 t1],[-100 100],'color','k')
line([t1-28 t1+28],[0 0],'color','k')
axis([t1-35 t1+35 -200 200])

% --------------------------------
function xclock

axis(1.75*[-1 1 -1 1])
x = sin(2*pi*(1:60)/60);
y = cos(2*pi*(1:60)/60);
k = 5:5:60;
line(x,y,'linestyle','none','marker','.','color','black','markersize',2);
line(x(k),y(k),'linestyle','none','marker','.','color','black','markersize',6);
h = line([0 0],[0 0],'color','blue','linewidth',2);
m = line([0 0],[0,0],'color','blue','linewidth',2);
c = clock;
t = c(4)/12 + c(5)/720 + c(6)/43200;
set(h,'xdata',[0 0.8*sin(2*pi*t)],'ydata',[0 0.8*cos(2*pi*t)])
t = c(5)/60 + c(6)/3600;
set(m,'xdata',[0 sin(2*pi*t)],'ydata',[0 cos(2*pi*t)])

% --------------------------------

function xfern
spy(finitefern(5000))
set(get(gca,'child'),'color',[0 2/3 0])
axis off

% --------------------------------

function xfernf
set(gcf,'numbertitle','off','name','FERN')
spy
i = get(get(gca,'child'),'ydata');
j = get(get(gca,'child'),'xdata');
S = sparse(450+i,290+j,1,768,1024);
clf
shg
axes('pos',[0 0 1 1])
F = imread('fern.jpg');
F = double((F(:,:,3)==255));
gci = image(2*F+1);
colormap([0 0 1/3; 1/2 1/2 2/3; 1 1 1])
axis off
F = xor(F,S);
set(gcf,'userd',F);
set(gca,'userd',S);
set(gci,'userd',1);
uicontrol('pos',[20 20 15 15],'style','push','callback','figure, fern')
cbs = ['F=get(gcf,''userd''); S=get(gca,''userd''); gci=get(gca,''child'');' ...
   'b=1-get(gci,''userd''); set(gci,''userd'',b,''cdata'',2*xor(b*S,F)+1)'];
uicontrol('pos',[40 20 15 15],'style','push','callback',cbs)
cbs = ['F=get(gcf,''userd''); S=get(gca,''userd''); gci=get(gca,''child'');' ...
   'b=1-get(gci,''userd''); set(gci,''userd'',b,''cdata'',max(2*b*S,F)+1)'];
uicontrol('pos',[60 20 15 15],'style','push','callback',cbs) 

% --------------------------------

function xlifex
rabbits = sparse(15,15);
rabbits(7:9,5:11) = [1 0 0 0 1 1 1; 1 1 1 0 0 1 0; 0 1 0 0 0 0 0];
[i,j] = find(rabbits);
plot(j,i,'.','markersize',10)
set(gca,'ydir','reverse')
axis([0 15 0 15])

% --------------------------------

function lifexf
lifex('rabbits',48)

% --------------------------------

function xrabbits
load rabbits.mat
bluebunny = cat(3,bunny,bunny,255*ones(size(bunny),'uint8'));
bluerabbit = cat(3,rabbit,rabbit,255*ones(size(rabbit)));
S = 255*ones(200,200,3,'uint8');
S(63:137,26:175,:) = cat(2,bluebunny,bluerabbit);
image(S);

% --------------------------------

function xhouse
H = house;
H(:,end+1) = H(:,1);
plot(H(1,:),H(2,:),'.-','markersize',6)
axis(16*[-1 1 -1 1])
axis off

% --------------------------------

function wigglehouse
H = house;
wiggle(H)

% --------------------------------

function xdurerperm
load detail
T = ones(560,560,3);
T(100+(1:359),95+(1:371),:) = ind2rgb(X,map);
image(T)

% --------------------------------

function xmandelbrot
load exmgui_pix
image(mandelbrot_pix);

% --------------------------------

function xbackslash
fs = get(0,'defaulttextfontsize');
text(.35,.50,'A\b','fontsize',fs+6,'fontweight','bold', ...
   'interpreter','none')
box on

% --------------------------------

function backslashf
close
doc slash

% --------------------------------

function xtpuzzle
load exmgui_pix
image(tpuzzle_pix);

% --------------------------------

function xexpgui
x = 0:.01:2;
a = 2;
plot(x,[a.^x; log(a)*a.^x])
axis([-.5 2.5 -2 8])

% --------------------------------

function xwaterwave
load exmgui_pix
image(waterwave_pix)

% --------------------------------

function xpredprey
mu = [300 200]';
eta = [400 100]';
sig = [1 -1]';
ppode = @(t,y) sig.*flipud(1-y./mu).*y;
pit = 6.5357;
[t,y] = ode45(ppode,[0 3*pit],eta);
plot(y(:,1),y(:,2),'k-')
line(mu(1),mu(2),'marker','.','color',[1 0 0],'markersize',24)
line(eta(1),eta(2),'marker','.','color',[0 1/2 1/2],'markersize',24)
axis([0 600 -50 550])
box on

% --------------------------------

function xtictactoe
M = magic(3);
for i = 1:3
   for j = 1:3
      kolor = 'white'; 
      if i==j, kolor = 'green'; end
      if abs(i-j)==2, kolor = 'blue'; end
      uicontrol('units','normal','string',int2str(M(i,j)),'back',kolor, ...
         'style','toggle','fontsize',10,'fontweight','bold', ...
         'position',[.61+.035*i .53+.04*j .035 .04], ...
         'callback','figure; tictactoe')
   end
end
box on

% --------------------------------

function miniweb
x = [-.25 1.25 1.25 -.25 -.25];
y = [0 0 1 1 0];
plot(1+x,7+y,'k-',...
     3+x,5+y,'k-',...
     3+x,3+y,'k-',...
     5+x,7+y,'k-',...
     1+x,1+y,'k-',...
     5+x,1+y,'k-');
axis([-2 9 -2 11])
set(gca,'xtick',[],'ytick',[])
hold on
x = [2 3]; y = [7 6]; arrow(x,y)
x = [3.5 3.5]; y = [5 4]; arrow(x,y)
x = [4 5]; y = [6 7]; arrow(x,y)
x = [4 5.25]; y = [4 7]; arrow(x,y)
x = [4 5]; y = [3 2]; arrow(x,y)
x = [3 2]; y = [3 2]; arrow(x,y)
x = [4.75 2.25]; y = [7.5 7.5]; arrow(x,y)
x = [1.3 1.3]; y = [2 7]; arrow(x,y)
x = [1.7 1.7]; y = [7 2]; arrow(x,y)
hold off

% --------------------------------

function arrow(x,y)
plot(x,y,'k-')
e = .3;
a = [0 -e -e/2 -e 0; 0 e/2 0 -e/2 0];
t = 3*pi/2 + atan2(x(2)-x(1),y(2)-y(1));
G = [cos(t) sin(t); -sin(t) cos(t)];
a = G*a;
fill(x(2)+a(1,:),y(2)+a(2,:),'k-')

% --------------------------------

function pagerankf
load harvard500
pagerank(U,G);
spy(G);

% --------------------------------

function xsudoku
load exmgui_pix
image(sudoku_pix)

% --------------------------------

function xpianoex
load exmgui_pix
image(pianoex_pix)

% --------------------------------

function xmorse
load exmgui_pix
image(morse_pix)

% --------------------------------

function xorbits

load exmgui_pix
P = orbits_init;
S = orbits_traj;
dotsize = [36 18 24 30 20]';
color = [4 3 0; 2 0 2; 1 1 1; 0 0 3; 4 0 0]/4;
s = 22/16;
axis([-s s -s s -s/4 s/4])
axis off
for i = 1:5
   line(P(i,1),P(i,2),P(i,3),'color',color(i,:), ...
      'marker','.','markersize',dotsize(i));
   line(S(:,1,i),S(:,2,i),S(:,3,i),'color',color(i,:));
end
drawnow

% --------------------------------

function helpwin_exm
helpwin exm
close

% --------------------------------

function helpwin_exmgui
helpwin exmgui
close

% --------------------------------

function xclose
close
close

% --------------------------------

function xnothere
u = get(gcf,'userdata');
u{24} = @xscream;
set(gcf,'userdata',u)
text(.1,.4,'Do not click here.')

% --------------------------------

function xscream
u = get(gcf,'userdata');
u{24} = @scream;
set(gcf,'userdata',u)
set(findobj('string','Do not click here.'),'string','scream')

