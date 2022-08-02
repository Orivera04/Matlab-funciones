% f2_11 same as L2_16 : Figure 2.11 
% Illustration of subplots
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.11; List 2.16')

clear,clf,hold off
t=0:.3:30;
subplot(2,2,1), plot(t,sin(t)),title('SUBPLOT 2,2,1')
              xlabel('t'); ylabel('sin(t)')
subplot(2,2,2), plot(t,t.*sin(t)),title('SUBPLOT 2,2,2')
              xlabel('t'); ylabel('t.*sin(t)')
subplot(2,2,3), plot(t,t.*sin(t).^2),title('SUBPLOT 2,2,3')
              xlabel('t'); ylabel('t.*sin(t).^2')
subplot(2,2,4), plot(t,t.^2 .*sin(t).^2),title('SUBPLOT 2,2,4')
              xlabel('t'); ylabel('t.^2.*sin(t).^2')

