% L10_7 same as f10_12
% Copuright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.12; List 10.7')
clear, clf
y= [1,0]'; % initial condition
M=0.5; k = 100; B=10; a = B/M; 
b = k/M; n=0; t=0; h = 0.025;
y_rec(:,1) = y; t_rec(1)=0;
while t<=1
  n=n+1;  
  k1 = h*f_sm(y,t,a,b);
  k2 = h*f_sm(y+k1,t+h,a,b);
  y = y + 0.5*(k1 + k2);
  t_rec(n+1) = n*h;
  y_rec(:,n+1) = y;   
  t = t+h;
end
clear y   t
y=y_rec; t=t_rec;
plot(t,y(1,:), '-', t,y(2,:),':');
text(0.45, -7.7, 't (s)','FontSize',[18])
text(-0.12, -4.5, ' u (m) and v (m/s)','FontSize',[18],'Rotation',[90])
text(t(5),y(1,5)+0.3,'Displacement, u','FontSize',[18])
text(t(10),y(2,10),'Velocity, v','FontSize',[18])
axis([0,1,-7,1.5])

set(gca,'FontSize',[18])
%print mp10SpringRK2.ps
