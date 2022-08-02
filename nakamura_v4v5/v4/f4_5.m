% f4_5
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.5')

clear,clg
h=pi/4;
x=0:h:pi;
y=sin(x);
xi = 0:h/8:pi;
yi = Lagran_(x,y,xi);
ye = sin(xi);
plot(xi,ye,xi,(ye-yi)*100)
hold on
plot(x,y,'o')
text(x(4)+0.2,y(4),'sin(x)','FontSize',[18])
text(0.5,+0.09,'100 X e(x);  e(x)=sin(x)-g(x)',...
                              'FontSize',[14])  
plot([0,pi], [0,0])

%hold off

%fprintf('sin(x) -,   e(x)X100 --')
%[xi,yi]=ginput(1)
text(-0.3557, 0.1097,'sin(x) ,   e(x)X100 --',...
                  'FontSize',[14],'Rotation',[90] )

%fprintf('ginput for x')
%[xi,yi]=ginput(1)
text(1.8106, -0.1891,'x','FontSize',[18])

axis([0,3.5,-0.1,1])
set(gca,'FontSize',[18])




