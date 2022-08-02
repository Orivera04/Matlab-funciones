function exmgui
%EXMGUI  Master GUI for "Experiments with MATLAB".
%  EXMGUI provides an interface to nineteen of the graphical demostrations
%  from "Experiments with MATLAB".  Click on any graphic to access
%  the underlying function.
%     fern       biorythm   clockex    lifex      rabbits
%     pagerank   wiggle     t_puzzle   tictactoe  backslash
%     predprey   mandelbrot durerperm  waterwave  expgui
%     touchtone  censusgui  swinger    walker     (help)

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
      case  2, xbiorhythm; f = @biorhythm; s = 'biorhythm';
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
      case 16, xtouchtone; f = @touchtone; s = 'touchtone';
      case 17, xcensus; f = @censusgui; s = 'censusgui';
      case 18, xswinger; f = @swinger; s = 'swinger'; 
      case 19, xwalker; f = @walker; s = 'walker';
      case 20, f = @exmlogo; text(.1,.4,'exmlogo'), box on
      case 21, f = @book; text(.1,.4,'exm book'), box on
      case 22, f = 'helpwin exmgui'; text(.1,.4,f), box on
      case 23, f = 'helpwin exm'; text(.1,.4,f), box on
      case 24, f = @close; text(.1,.4,'close'), box on
   end
   set(ax,'xtick',[],'ytick',[]);
   if k <= 19 
      axes('pos',axk), axis xy, axis off
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
t0 = 708434+fix(25056*rand);
t1 = fix(now);
t = (t1-28):1:(t1+28);
y = 100*[sin(2*pi*(t-t0)/23)
         sin(2*pi*(t-t0)/28)
         sin(2*pi*(t-t0)/33)];
plot(t,y)
line([t1 t1],[-100 100],'color','k')
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
S = sparse(500+i,290+j,1,768,1024);
clf
shg
set(gcf,'doublebuff','on')
axes('pos',[0 0 1 1])
F = imread('fern.png');
F = double((F(:,:,3)==255));
gci = image(2*F+1);
colormap([0 0 1/3; 1/2 1/2 2/3; 1 1 1])
axis off
F = xor(F,S);
set(gcf,'userd',F);
set(gca,'userd',S);
set(gci,'userd',1);
uicontrol('pos',[20 20 15 15],'style','push','callback', ...
   ['F=get(gcf,''userd''); S=get(gca,''userd''); gci=get(gca,''child'');' ...
    'b=1-get(gci,''userd''); set(gci,''userd'',b,''cdata'',2*xor(b*S,F)+1)']);
uicontrol('pos',[40 20 15 15],'style','push','callback', ...
   ['F=get(gcf,''userd''); S=get(gca,''userd''); gci=get(gca,''child'');' ...
    'b=1-get(gci,''userd''); set(gci,''userd'',b,''cdata'',max(2*b*S,F)+1)']);
uicontrol('pos',[60 20 15 15],'style','push','callback','fern')

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
R = 255*ones(102,100,3,'uint8');
R(30:76,31:75,:) = imread('rabbit.jpg');
image(R);

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
M = 255*ones(208,208,3,'uint8');
M(31:178,31:178,:) = imread('mandelbrot_small.jpg');
image(M);
axis equal

% --------------------------------

function xbackslash
fs = get(0,'defaulttextfontsize');
text(.30,.55,'Solve','fontsize',fs+2,'fontweight','bold')
text(.30,.40,'A*x = b','fontsize',fs+2,'fontweight','bold')
box on

% --------------------------------

function backslashf
close
doc slash

% --------------------------------

function xtpuzzle
T = 255*ones(620,511,3,'uint8');
T(141:540,141:431,:) = imread('tpuzzle.jpg');
T(501:end,303:end,:) = 255;
image(T);

% --------------------------------

function xexpgui
x = 0:.01:2;
a = 2;
plot(x,[a.^x; log(a)*a.^x])
axis([-.5 2.5 -2 8])

% --------------------------------

function xwaterwave
W = imread('waterwave.jpg');
image(W)

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

function xcensus
p = [ 75.995  91.972 105.711 123.203 131.669 150.697 ...
     179.323 203.212 226.505 249.633 281.422]';
t = (1900:10:2000)';
x = (1890:1:2019)';
w = 2010;
d = 3;
c = polyfit((t-1950)/50,p,d);
y = polyval(c,(x-1950)/50);
z = polyval(c,(w-1950)/50);
h = plot(t,p,'.',x,y,'-',w,z,'.');
axis([1870 2039 -80 480])
set(h(1),'markersize',12)
set(h(2),'linewidth',1)
set(h(3),'markersize',18,'color',[0 .75 0])
text(w-15,z+10,'?','fontweight','bold','color',[0 .75 0])

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

function xtouchtone
load touchtone
image(ind2rgb(D,gray(256)))
axis image
set(gca,'pos',get(gca,'pos')+[1  1 -2 -2]/20)
box on

% --------------------------------

function xswinger
s = .9/sqrt(2);
plot([0 s 0],[0 -s -2*s],'o-')
axis([-2 2 -2.75 1.75])

% --------------------------------

function xwalker
load walkers
L = {[1 5],[5 12],2:8,9:15};
X = reshape(M*[1;0;1;0;1],15,3);
ms = ceil(get(0,'defaultlinemarkersize')/2);
for k = 1:4
   line(X(L{k},1),X(L{k},2),X(L{k},3),'linestyle','-', ...
      'marker','o','markersize',ms);
end
axis([-600 600 -600 600 -200 1600])
set(gca,'xtick',[],'ytick',[],'ztick',[])
view(160,10)
axis off
pause(.1)

% --------------------------------

function book
T = { ...
'Experiments with MATLAB'
'by Cleve Moler'
' '
'Electronic edition, MathWorks'
'   http://www.mathworks.com/moler'
' '};
set(gcf,'color','white')
darkblue = [0 0 2/3];
axes('pos',[0 0 1 1])
axis off
text(.1,.55,T,'fontsize',20,'color',darkblue,'interpreter','none');
uicontrol('units','norm','pos',[4/5 0 1/5 1/16],'string','close', ...
   'back','white','callback','close(gcf)')

