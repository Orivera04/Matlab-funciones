% Create lots of different object on the figure

clf

subplot(221)

hold on
tt = linspace(-pi/2,pi/2,101);
x = [tt tt(length(tt):-1:1)];
y = [cos(tt) -cos(tt)];
patch(x,y,[.9 .9 .95])

t = linspace(0,2*pi,101);
patch(cos(t),sin(t),[.6 .7 .75])
patch(.2*cos(t),.2*sin(t),'k')

str = {'The eye is the';'light of the soul'};
text(.5,.5,str)

axis equal

subplot(222)
x = rand(20,1);
y = rand(20,1);
hold on
for i=1:20
  plot(x(i),y(i),'.','MarkerSize',30,'Color',rand(1,3))
end

subplot(223)
[x,y,z] = peaks(21);
[m,n] = size(z);
m = floor(m/2);
n = floor(n/2);
z(1:m,1:n) = NaN*ones(m,n);
surf(x,y,z);
hold on
axis tight
ax = axis;
x = rand(20,1);
y = rand(20,1);
z = rand(20,1);
x = fitrange(x,ax(1),ax(2));
y = fitrange(y,ax(3),ax(4));
z = fitrange(z,ax(5),ax(6));
hold on
for i=1:20
  plot(x(i),y(i),'.','MarkerSize',30,'Color',rand(1,3))
end
xyz
title('Title goes here');


subplot(224)
load clown
image(X)
colormap(fitrange(gray,.5,1))
uicontrol('units','norm',...
    'pos',[.578 .11+.3439-.1 .327 .1],...
    'String','Push Me!',...
    'Callback','disp(''Aaahh...'')')

uicontrol('units','norm',...
    'pos',[.578 mean([.11+.3439-.1 .11]) .327 .1],...
    'String','No: Push Me!',...
    'Callback','disp(''That''''s better!'')')

uicontrol('units','norm',...
    'pos',[.578 .11 .327 .1],...
    'String','Don''t push any of us!',...
    'Callback','disp(''Don''''t do that!'')')

