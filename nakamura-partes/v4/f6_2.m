% f6_2
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 6.2')

clear,clf
alph=['a','b','c','d','e','l'];
hold on
x= [-2 -1 0 1 2 3];
y=zeros(size(x)) -3;
plot(x,y+1,'o')
plot([-2.5, 3.5], [0 0]+1-3)
for i=1:length(x)
text(x(i)-0.15,y(i)+1.5, 'x',  'FontSize', [16])
text(x(i)+0.1-0.155,y(i)+1.3, num2str(x(i)),  'FontSize', [16])
text(x(i)-0.15,y(i)+0.5,['i=',num2str(x(i))],  'FontSize', [16])

% text(x(i)-0.15,y(i)-0.5,'i=', 'FontSize', [18], 'FontName','Courier')
% text(x(i)+0.2,y(i)-1,alph(i), 'FontName','Symbol', 'FontSize', [18])
end

text(-2.5,2.5-3,'An example with 6 equispaced points:')
text(-2.5,-1+0.2,'(L = 6)')
text(-2.5,3.2,'Total number of points = L')
text(-2.5,-0.5+4,'Non-equispaced points:')
y=y+7;
x(2)=x(2)-0.2;
x(4)=x(4)+0.5;
x(5)=x(5)+0.3;
plot(x,y-2,'o')
plot([-2.5, 3.5], [0 0]+2)
axis([-2.5, 3.5, -2.599 , 3.5])

for i=1:length(x)
if i==1 | i==2| i==length(x)
text(x(i)-0.15,y(i)-1.5, 'x',  'FontSize', [16])
text(x(i)-0.15,y(i)-2.5,'i=',  'FontSize', [16])

%text(x(i)-0.15,y(i)-0.5,'i=', 'FontSize', [18], 'FontName','Courier')
text(x(i)+0.2-0.22,y(i)-1.7,alph(i), 'FontName','Symbol', 'FontSize', [18])
text(x(i)+0.2-0.15,y(i)-2.5,alph(i), 'FontName','Symbol', 'FontSize', [18])
end
end
i=3; text(x(i)-0.15,y(i)-1.5, 'x=0',  'FontSize', [16])
text(x(i)-0.15,y(i)-2.5,'i=0',  'FontSize', [16])
i=4; text(x(i),y(i)-2.5,'..',  'FontSize', [16])
axis('off')

