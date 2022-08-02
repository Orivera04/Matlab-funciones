% L10_3 same as f10_5
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.5; List 10.3')

clear,clf,hold off
h = 0.05; t_max=5; n=1;
y(:,1) = [0; 1];
t(1) = 0;
while t(n)< t_max
   y(:,n+1) = y(:,n) + h*f_def(y(:,n),t); yb=y;
   t(n+1) = t(n)+h ;
   n=n+1;
end
axis([0 5 -1 1])
plot(t, y(1,:), t, y(2,:),':')
xlabel('time (s)'); ylabel('Y and V  ')
L=length(t);
text(t(L), y(1,L), 'Y, displacement')
text(t(L), y(2,L), 'V, velocity')








