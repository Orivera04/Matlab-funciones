% f10_16 same as L10_10
% Copyright S. Nakamura 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.16; List 10.10')
clear, clf
M1 = 1; M2 = 1; M3 = 1; 
K1 = 1; K2 = 1; K3 = 1;
F1 = 1; F3 = 0; F = [0, 0, 0, F1/M1, 0, F3/M3]';
B1 = 0.1; B3 = 0.1;
y=[0; 0; 0; 0; 0; 0];
y_rec(:,1)=y; t_rec = 0; n=0;
h = 0.1;t = 0;
C = [0,     0,        0,        1,     0,     0; ...
     0,     0,        0,        0,     1,     0; ...
     0,     0,        0,        0,     0,     1; ...
  -K1/M1,  K2/M1,     0,    -B1/M1,  B1/M1,   0; ...
   K1/M2,-(K1+K2)/M2, K2/M2, B1/M2, -B1/M2,   0; ... 
   0,      K2/M3, -(K2+K3)/M3,  0,     0,   -B3/M3];
while t<=30
  n=n+1;  
    k1 = h*F3m_(y,C,F);
    k2 = h*F3m_(y+k1/2,C,F);
    k3 = h*F3m_(y+k2/2,C,F);
    k4 = h*F3m_(y+k3,C,F);
  y = y + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
  t_rec(n+1) = n*h;
  y_rec(:,n+1) = y;   
  t = t+h;
end
plot(t_rec,y_rec(1:3,:))
text( t_rec(70), y_rec(1,70)-0.4, 'y1')
text( t_rec(70), y_rec(2,70)-0.4, 'y2')
text( t_rec(70), y_rec(3,70)-0.4, 'y3')
xlabel('time (s)')
ylabel('Displacements, y1, y2, and y3')

