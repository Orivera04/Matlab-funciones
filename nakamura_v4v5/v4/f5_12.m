% f5_12 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.12')

clear, clg, hold off
x= 1:0.1:5;
k = 1:10;
m = 1:10;
x=k/10;
hold on
for m=1:10
x=2*(k/10 - m/50) + 2;

y = log(x) + tan(m/10);
plot(x,y)

end

for k=1:10
 m=1:10;

%x=k/10 - m/50 + 2;
x=2*(k/10 - m/50) + 2;

y = log(x) + tan(m/10);
plot(x,y)

end
axis([1.5 4, 0.5,3])
m=1; k=1;
x=2*(k/10 - m/50) + 2;
y = log(x) + tan(m/10);
plot(x,y,'o')
text(x-0.1,y-0.1,'(1,1)','FontSiz',[18])
 
m=1; k=7;
x=2*(k/10 - m/50) + 2;
y = log(x) + tan(m/10);
plot(x,y,'o')
text(x-0.1,y-0.1,'(i,1)','FontSize',[18])

m=6; k=7;
x=2*(k/10 - m/50) + 2;
y = log(x) + tan(m/10);
plot(x,y,'o')
text(x-0.1,y-0.1,'(i,j)','FontSize',[18])

m=6; k=1;
x=2*(k/10 - m/50) + 2;
y = log(x) + tan(m/10);
plot(x,y,'o')
text(x-0.1,y-0.1,'(1,j)','FontSize',[18])


plot([1.5 2], [0.5, 0.5])
text(2.1,0.5,'x','FontSize',[18])

plot([1.5, 1.5], [0.5, 1])
text(1.5,1.2, 'y','FontSize',[18])

axis('off')
%print fig5_12.ps
