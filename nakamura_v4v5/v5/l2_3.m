% L2_3 : Figure 2.2 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.2;  List 2.3')

clear,clf,hold off
p=0: 0.05: 8*pi;
z=(cos(p) + i*sin(2*p)).*exp(-0.05*p) + 0.01*p;
plot(real(z), imag(z))
xlabel('Re(z)'); ylabel('Im(z)')

