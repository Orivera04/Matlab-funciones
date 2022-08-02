% f10_2   same as L10_1
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.2; List 10.1')

clear,clg
t = 0; n=0; v=0;
C = 0.27;
; M = 70; g = 9.8; h = 0.1;
t_rec(1)=t; v_rec(1) = v;

while t<20
   n=n+1;
   v = v + h*( -C/M*v*v + g);
   t = t+h;
   v_rec(n+1) = v; 
   t_rec(n+1) = t;
end
 plot(t_rec,v_rec)
axis([0,20,0,60])
hh=text( 11.8707,  -4.5748, 't (s)');   
set(hh,'FontSize',[18]);
hh=text(-2.0785,  16.0117, 'velocity (m/s)');
set(hh,'FontSize',[18], 'Rotation',[90])
