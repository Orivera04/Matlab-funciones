% f5_11 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 5.11')

clear, clg, hold off
x= 1:0.1:5;
k = 1:10;
m = 1:10;
x=k/10;
hold on
for m=1:9:10
x=2*(k/10 - m/50) + 2;

y = log(x) + tan(m/10);
plot(x,y)

end

for k=1:9:10
 m=1:10;
%x=k/10 - m/50 + 2;
x=2*(k/10 - m/50) + 2;

y = log(x) + tan(m/10);
plot(x,y)

end
axis([1.5 4, 0.5,3])

%m=1; k=1
%x=2*(k/10 - m/50) + 2;
%y = log(x) + tan(m/10);
%plot(x,y,'o')
%text(x-0.1,y-0.1,'(1,1)')
% 
%m=1; k=7
%x=2*(k/10 - m/50) + 2;
%y = log(x) + tan(m/10);
%plot(x,y,'o')
%text(x-0.1,y-0.1,'(i,1)')
%
%m=6; k=7
%x=2*(k/10 - m/50) + 2;
%y = log(x) + tan(m/10);
%plot(x,y,'o')
%text(x-0.1,y-0.1,'(i,j)')
%
%m=6; k=1
%x=2*(k/10 - m/50) + 2;
%y = log(x) + tan(m/10);
%plot(x,y,'o')
%text(x-0.1,y-0.1,'(1,j)')


%plot([1.5 2], [0.5, 0.5])
%text(2.1,0.5,'x')
%
%plot([1.5, 1.5], [0.5, 1])
%text(1.5,1.2, 'y')

%axis('off')

xlabel('x'), ylabel('y')
text(2.2,1.8,'D: domain of integration','FontSize',[18])
%print fig5_11.ps




