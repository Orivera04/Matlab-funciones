% fig10_9 same as L10_5
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.9; List 10.5')

clear,clg    %x10_8mains.m
R = 20;      %ohm
L = 50e-3;   %H
E = 10;      %V
y=0; 
h = 0.1e-3;
n=0;
y_rec(1)=y; t_rec(1)=0;t=0;
RL = R/L;  EL=E/L;
while t<0.02 
   n=n+1; RL;EL;
   k1 = h*f_x10_9(y, RL, EL);
   k2 = h*f_x10_9(y+k1, RL, EL);
   y = y + 0.5*(k1+k2);
   t = (n-1)*h;
   y_rec(n+1)=y; t_rec(n+1)=t;
end
plot(t_rec,y_rec )
text(0.008, -0.047, 'time (s)','FontSize',[18])
text(-0.0027, 0.2,'I (A) ','FontSize',[18],'Rotation',[90])
set(gca,'FontSize',[18])
%print x10_9main.ps
