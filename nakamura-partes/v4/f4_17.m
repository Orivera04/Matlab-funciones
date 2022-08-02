% f4_17
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.17')

clear
clf
x=[0 1.0, 2.4, 5,7,8];
y=[0,1,2.1, 3.5,4.5,6];
[xm,ym]=meshgrid(x,y);
mesh(xm,ym,ones(size(xm)));
for i=1:2
text(x(i)-0.1,-0.3,['X'])
text(x(i)-0.1,-0.4,['  ',int2str(i)])
end
 i=3;  text(x(i)-0.1,-0.3,[' .'])
 i=5;  text(x(i)-0.1,-0.3,[' .'])
 i=4;
text(x(i)-0.1,-0.3,['X'])
text(x(i)-0.1,-0.4,['  m'])
 i=length(x);
text(x(i)-0.1,-0.3,['X'])
text(x(i)-0.1+0.04,-0.4,['  M'])
for j=1:2
if j < 3,  text(-0.6,y(j),['Y']), end
if j < 3,  text(-0.6,y(j)-0.1,['  ',int2str(j)]), end
end
 j= 4;  text(-0.6,y(j),['Y'])
 j= 4;  text(-0.6,y(j)-0.1,['  n'])
 j= 3;  text(-0.6,y(j),' .')
 j= length(y)-1;  text(-0.6,y(j),' .')
 j= length(y);  text(-0.6,y(j),'Y')
 j= length(y);  text(-0.6,y(j)-0.1,'  N')
axis([0,8,0,6])
axis('off')
