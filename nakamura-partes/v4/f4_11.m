% f4_11
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.11')

clear, clg
k=9;
i = 0:k;
xp = 0.5*( (5-0)*cos((k-i)*pi/k) + 5 );
yp = zeros(size(xp));
k1 = k+1;
xi=xp; yi = yp;
hold on
xmax=5;  h = xmax/300;
x=0:h:xmax;
y=ones(size(x));
for k=1:k1
y = y.*( x-xi(k))/k;
end
plot(x,y, xi,zeros(size(xi)),'o')
text(1.5, 1.0440e-05,  'Ten Lobatto points and L(x)',...
                              'FontSize',[14]);
text( 2.8, -1.7933e-05,  'x', 'FontSize',[14]);
text( -0.55, -4.1056e-07, 'L(x)', 'FontSize',[14]);
