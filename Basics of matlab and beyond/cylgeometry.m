set(0,'defaultaxeslinewidth',.01)
set(0,'defaultlinelinewidth',.2)
N = 20;
dt = 2*pi/N;
t = 0:dt:(N-1)*dt;
x = [cos(t) cos(t)];
y = [sin(t) sin(t)];
z = [zeros(size(t)) ones(size(t))];
vert = [x' y' z'];
faces = [1 N+1 N+2 2
    2 N+2 N+3 3
    N-1 2*N-1 2*N N
    N 2*N N+1 1];

clf
h = patch('vertices',vert,'faces',faces,...
    'facecolor','none');
view(52.5,30)
hold on
plot3(x,y,z,'k.','markersize',15)
plot3(x(1:N),y(1:N),z(1:N),'k:')
plot3(x(N+1:2*N),y(N+1:2*N),z(N+1:2*N),'k:')

for i=1:3
  text(x(i),y(i),z(i),int2str(i),'FontSize',20,...
      'Vert','top','FontAngle','Italic');
end
text(x(4),y(4),z(4),'. . .','FontSize',20,...
    'Vert','top');
text(x(N-2),y(N-2),z(N-2),'. . .','FontSize',20,...
    'Vert','top','hor','right');
text(x(N),y(N),z(N),'N','FontSize',20,'FontAngle','Italic',...
    'Vert','top','hor','cen');
text(x(N-1),y(N-1),z(N-1),'N-1','FontSize',20,'FontAngle','Italic',...
    'Vert','top','hor','cen');
text(x(N+1),y(N+1),z(N+1),'N+1','FontSize',20,'FontAngle','Italic',...
    'Vert','bot','hor','cen');
text(x(N+2),y(N+2),z(N+2),'N+2','FontSize',20,'FontAngle','Italic',...
    'Vert','bot','hor','cen');
text(x(N+3),y(N+3),z(N+3),'N+3','FontSize',20,'FontAngle','Italic',...
    'Vert','bot','hor','cen');
text(x(2*N),y(2*N),z(2*N),'2N','FontSize',20,'FontAngle','Italic',...
    'Vert','bot','hor','cen');
text(x(2*N-1),y(2*N-1),z(2*N-1),'2N-1','FontSize',20,'FontAngle','Italic',...
    'Vert','bot','hor','cen');
  

b = 1.5;
axis(b*[-1 1 -1 1 0 1])
view(100,40)
arrow([0 0 0],[b 0 0],'length',4)
text(b,0,0,'x','fontangle','italic','hor','cen','vert','top','FontSize',20)
arrow([0 0 0],[0 b 0],'length',4)
text(0,b,0,'y','fontangle','italic','FontSize',20)
arrow([0 0 0],[0 0 1],'length',4)
text(0,0,1,'z','fontangle','italic','hor','cen','vert','bot','FontSize',20)
axis off
q = .815/.775;
set(gca,'pos',[-.1 0.05 1.1 q*1.1])
