% L10_4 same as f10_7
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.7; List 10.4')

clear;    %x10_8mains.m
clear, clf, hold off
R = 100;      %ohm
L = 200e-3;   %H
C = 10e-6;    %F
E = 1;
h = 0.25e-3;
n=1;
t(1)=0; y(:,1)=[0;0];
M=[0,1;-1/(L*C), -R/L]; S = [0;E/L];
while n<101
   y(:,n+1) = y(:,n) + h*(M*y(:,n)+S);
   t(n+1) = n*h;
   n=n+1;
end
plot(t,100*y(1,:),t,y(2,:),'--' )
text(t(30), 119*(y(1,30)), 'Qx100')
text(t(28), y(2,30), 'I')
xlabel('time (s)')
ylabel('I (A) and Q (A*s)')

%print x10_8mains.ps
