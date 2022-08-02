set(gcf,'color','w')
clf

subplot(221)
x = linspace(-1,1);
plot(x,x.^2,'k')
hold on
plot(0,.25,'xk')
text(0,.3,'Focus','Vert','bot','hor','cen')
text(.68,.71.^2,'y = x^2','Vert','bot','hor','right')
box
axis image

hax = axes;
[r,theta] = meshgrid(0:.5:4,0:pi/20:2*pi);
z = r.^2;
h = polarsurfl(r,theta,z);
set(h,'Edgecolor',[.5 .5 .5])
colormap(range(gray,.5,1))
view(-32,60)
hold on
set(hax,'pos',[.5 .5 .5 .5],'vis','off')
N = size(r,2);
plot3(r(:,N).*cos(theta(:,N)),r(:,N).*sin(theta(:,N)),z(:,N),'k')

subplot(223)
load clown 
image(X)
%ntsc

subplot(224)
% Draw a ship

shipgray = [.7 .75 .75];
% Hull:
vert = [...
 -1	.7	0
  0.8	0.8	0
  1.3	0	0
  0.8	-.8	0
  -1	-.7	0
  -1	1	1
  1	1	1
  1.5	0	1.2
  1	-1	1
 -1	-1	1];

vert(:,1) = 5*vert(:,1);
vert(:,3) = 0.7*vert(:,3);

faces = {...
[1 2 7 6];
[2 3 8 7];
[3 8 9 4];
[4 9 10 5];
[1 5 10 6];
[6 7 8 9 10];
[1 2 3 4 5]};

subplot(224)
for i=1:size(faces,1)
  patch('Vertices',vert,'Faces',faces{i},'FaceColor',shipgray,...
        'EdgeColor',0.5*shipgray)
end

% Superstructure:
neck = 0.5;
vert = [...
-1	1	0
-.6	1	0
-.2	(1 - neck)	0
.2	(1 - neck)	0
.6	1-neck/2	0
1	1-neck/2	0
1	-(1-neck/2)	0
.6	-(1-neck/2)	0
.2	-(1 - neck)	0
-.2	-(1 - neck)	0
-.6	-1	0
-1	-1	0
-1	1	1
-.6	1	1
-.2	(1 - neck)	1
.2	(1 - neck)	1
.6	1-neck/2	1
1	1-neck/2	1
1	-(1-neck/2)	1
.6	-(1-neck/2)	1
.2	-(1 - neck)	1
-.2	-(1 - neck)	1
-.6	-1	1
-1	-1	1];
vert(:,1) = 3*vert(:,1) + 1;
vert(:,3) = 0.8*vert(:,3) + .7;
faces = [...
1 2 14 13
2 3 15 14
3 4 16 15
4 5 17 16
5 6 18 17
6 7 19 18
8 7 19 20
9 8 20 21
10 9 21 22
11 10 22 23
12 11 23 24
1 12 24 13];
patch('Vertices',vert,'Faces',faces,'FaceColor',shipgray,...
        'EdgeColor',0.5*shipgray)
faces = 13:24;
patch('Vertices',vert,'Faces',faces,'FaceColor',shipgray,...
        'EdgeColor',0.5*shipgray)

view(54,34)

x = linspace(-1,1,20);
xpos = linspace(6,0,20);
ypos = linspace(-5,5,20);
zpos = range(x.^2,2,10);
axis equal vis3d

%uicontrol('Units','points', ...
%    'FontSize',12, ...
%    'Position',[265.976 20.3294 172.8 15.2471], ...
%    'Style','slider', ...
%    'Tag','Slider1');
h = uicontrol('Units','points', ...
    'FontSize',12, ...
    'Position',[440.471 37.2706 15.2471 138.071], ...
    'Style','slider', ...
    'Tag','Slider1');
set(h,'units','normal')

h = axes;
set(h,'pos',[0 0 1 1])
axis(axis)
hold on
xcurlabel = [ 0.15653 0.16369];
ycurlabel = [ 0.79594 0.92482];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
text(xcurlabel(2),ycurlabel(2),'Line','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
plt([.16369 .23],[.92482 .70286],'k')
xcurlabel = [ 0.27996 0.23];
ycurlabel = [ 0.70286 0.70286];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
xcurlabel = [ 0.16369 0.11538];
ycurlabel = [ 0.64797 0.56683];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
text(xcurlabel(2),ycurlabel(2)+0.015,'Axes (2D)','HorizontalAlignment','center','VerticalAlignment','top','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
xcurlabel = [ 0.16369 0.11538];
ycurlabel = [ 0.5 0.56683]-.045;
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)


xcurlabel = [ 0.16369 0.11538]+.41;
ycurlabel = [ 0.64797 0.56683];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
text(xcurlabel(2),ycurlabel(2)+0.015,'Axes (3D)','HorizontalAlignment','center','VerticalAlignment','top','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
xcurlabel = [ 0.16369 0.11538]+0.41;
ycurlabel = [ 0.5 0.56683]-.045;
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)



xcurlabel = [ 0.62522 0.6449];
ycurlabel = [ 0.8222 0.94391];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
harrow = arrow(start,stop);
set(harrow,'zdata',10*ones(size(get(harrow,'xdata'))))
text(xcurlabel(2),ycurlabel(2),'Surface','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
xcurlabel = [ 0.18515 0.21377]+.1;
ycurlabel = [ 0.40692 0.49045];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
text(xcurlabel(2),ycurlabel(2),'Image','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
xcurlabel = [ 0.6932 0.74866];
ycurlabel = [ 0.34726 0.47136];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
harrow = arrow(start,stop);
set(harrow,'zdata',10*ones(size(get(harrow,'xdata'))))
text(xcurlabel(2),ycurlabel(2),'Patch','HorizontalAlignment','cen','VerticalAlignment','bot','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
xcurlabel = [ 0.9347 0.85957]-0.01;
ycurlabel = [ 0.37112 0.52625];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
text(xcurlabel(2),ycurlabel(2),'Uicontrol','HorizontalAlignment','cen','VerticalAlignment','bot','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
xcurlabel = [ 0.37299 0.3229];
ycurlabel = [ 0.79117 0.92721];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
xcurlabel = [ 0.28712 0.3229];
ycurlabel = [ 0.73866 0.92721];
start = [xcurlabel(2) ycurlabel(2)];
stop = [xcurlabel(1) ycurlabel(1)];
arrow(start,stop)
text(xcurlabel(2),ycurlabel(2),'Text','HorizontalAlignment','center','VerticalAlignment','bottom','FontName','Times',...
'FontSize',18,...
'FontWeight','bold')
box
set(gca,'xtick',[],'ytick',[],'color','none')

