% EX8_10.M Plot f(t)=exp(-t), t=[0,4] and 
%  the magnitude of the Fourier transform 
%
t=[0:.1:4];               % Range in time
foft=exp(-t);             %
% Plot magnitude of F(w)
w=[-4:.1:4];
Fw=1./(sqrt(1+w.^2));     % Fourier transform
%
clf                       % Clear any figures
subplot(2,1,1), plot(t,foft)
xlabel('t')
ylabel('f(t)')
title('Fourier Transform of f(t)=exp(-t) - Figure 8.9')	
subplot(2,1,2), plot(w,Fw)
axis([-4 4 0 1.1])
xlabel('Radian frequency w')
ylabel('|F(w)|')
 
