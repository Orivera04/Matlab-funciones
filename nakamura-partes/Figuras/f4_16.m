% f4_16
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.16')

clear,clf
axis([0 6 0 6])
hold on
x=[1,   3,  5 ];
y=[1,3,5];
for i=1:3
plot([0,6],[y(i),y(i)])
end

for i=1:3
plot([x(i),x(i)], [0,6] )
end
  
for i=1:length(x)
text(x(i)-0.1,-0.3,['x' ])
if i==1,text(x(i)+0.05,-0.4,['i-1' ])
elseif i==2,text(x(i)+0.05,-0.4,['i' ])
elseif i==3,text(x(i)+0.05,-0.4,['i+1' ])
end
end
for j=1:length(y)
text(-0.6,y(j),['y' ])
if j==1,text(-0.45,y(j)-0.1,['j-1' ])
elseif j==2,text(-0.45,y(j)-0.1,-0.37,['j' ])
elseif j==3,text(-0.45,y(j)-0.1,-0.37,['j+1' ])
end
end
axis([0,8,0,6])

for i=1:2
for j=1:2
plot(x(i),y(j),'o')
end
end
plot([1, 3],[2.2,2.2],':')
text(1-0.2, 2.2,'E')
text(3.05, 2.2, 'F')
text(2.2,2.2,'o')
text(2.1,1.9,'(x,y)', 'FontSize',[14])
axis('off')
