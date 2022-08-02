% f4_9b
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.9b')

clear, clg
%subplot(221)
k=9;
i = 1:k;
dx=5/8;
xp = 0:dx:5 ;
yp = zeros(size(xp));
xi=xp; yi = yp;
hold on
xmax=5;  h = xmax/300;
x=0:h:xmax;
y=ones(size(x));
for k=1:9
y = y.*( x-xi(k))/k;
end
plot(x,y, xi,zeros(size(xi)),'o')
%fprintf('title')
%[xi,yi]=ginput(1)
text(1, 1.5425e-04,'(b)  Nine equispaced points and L(x)',...
                           'FontSize',[14])
%fprintf('title')
%[xi,yi]=ginput(1)
text(2.482,-2.4106e-04,'x','FontSize',[14])
%fprintf('y')
%[xi,yi]=ginput(1)
text(-0.5788,-5.2786e-06,'L(x)','FontSize',[14])
set(gca, 'FontSize',[14])

