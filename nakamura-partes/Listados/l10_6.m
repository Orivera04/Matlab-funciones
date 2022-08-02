% L10_6 same as f10_10 
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.10; List 10.6')
clear
ro=300; V=0.001; A = 0.25; C = 900;hc=30;
epsi=0.8;sig=5.67e-8;
h = 1; T = 473; n=1;T_rec(n)=T; t(1)=0;
Arcv = A/(ro*C*V);  Epsg = epsi*sig;
while t<180
  n=n+1;  TB=T;
  k1 = h*Arcv*( Epsg*(297^4 - TB^4) + hc*(297-TB));
  k2 = h*Arcv*( Epsg*sig*(297^4 - (TB+k1)^4) ...
                                   + hc*(297-(TB+k1)));
  T = TB + 0.5*(k1 + k2);
  t(n)=t(n-1) + h;  T_rec(n)=T;
end
plot(t,T_rec);  xlabel('time (s)'), ylabel(' T  (K)')
%print x10_10.ps
