
% Script showint.m 
% Plot of the function 1/(1 + x^2) and its
% interpolating polynomial of degree n.

m = input('Enter number of interpolating polynomials ');
for k=1:m
   n = input('Enter degree of the interpolating polynomial ');
   hold on
   x = linspace(-5,5,n+1);
   y = 1./(1 + x.*x);
	z = linspace(-5.5,5.5);
   t = 1./(1 + z.^2);
   h1_line = plot(z,t,'-.');
   set(h1_line, 'LineWidth',1.25)
   t = Newtonpol(x,y,z);
   h2_line = plot(z,t,'r');
   set(h2_line,'LineWidth',1.3,'Color',[0 0 0])
   axis([-5.5 5.5 -.5 1])
   title(sprintf('Example of divergence (n =  %2.0f)',n))
   xlabel('x')
   ylabel('y')
   legend('y = 1/(1+x^2)','interpolant')
   hold off
end

