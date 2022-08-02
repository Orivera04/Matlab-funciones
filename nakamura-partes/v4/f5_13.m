% f5_13
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.13')

clear, clg, hold off
x= 1:0.1:5;
k = 1:10;
x=k/10;
hold on
for m=1:10
x=k;
y = ones(size(k))*m;
plot(x,y)

end

for k=1:10
 m=1:10;
%x=k/10 - m/50 + 2;
x=k*ones(size(m));

y = m;
plot(x,y)

end
m=1; k=1;
x=k;y=m;
plot(x,y,'o')
text(x-0.4,y-0.4,'(1,1)','FontSize',[18])
 
m=1; k=7;
x=k;y=m;
plot(x,y,'o')
text(x-0.4,y-0.4,'(i,1)','FontSize',[18])

m=6; k=7;
x=k;y=m;
plot(x,y,'o')
text(x-0.4,y-0.4,'(i,j)','FontSize',[18])

m=6; k=1;
x=k;y=m;
plot(x,y,'o')
text(x-0.4,y-0.4,'(1,j)','FontSize',[18])

xlabel('xi')

ylabel('eta')
axis('square')

axis([0 11 0 11])
%axis('off')
