% f4_9a
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.9a')

clear, clg
%subplot(221)
k=9;
%x=-1:0.02:1;
%y = cos(k*acos(x));
i = 1:k;
xp = 0.5*( (5-0)*cos((k+0.5-i)*pi/k) + 5 );
yp = zeros(size(xp));
%plot(xp,yp,'o')
%axis('square')
%axis([0 5   -1 1])
%title('T9(x)')
xi=xp; yi = yp;
hold on
xmax=5;  h = xmax/300;
x=0:h:xmax;
y=ones(size(x));
for k=1:9
y = y.*( x-xi(k))/k;
end
plot(x,y, xi,zeros(size(xi)),'o')
axis([0,5,-2e-4, 2e-4])

%fprintf('title')
%[xi,yi]=ginput(1)
text(1, 1.5425e-04,'(a)  Nine Chebyshev points and L(x)',...
                           'FontSize',[14])
%fprintf('title')
%[xi,yi]=ginput(1)
text(2.482,-2.4106e-04,'x','FontSize',[14])
%fprintf('y')
%[xi,yi]=ginput(1)
text(-0.5788,-5.2786e-06 ,'L(x)','FontSize',[14])
set(gca, 'FontSize',[14])

