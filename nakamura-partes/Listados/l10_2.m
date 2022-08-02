% L10_2 same as f10_3 
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.3; List 10.2')

clear, clf
%===== Forward Euler
yf(1) = 10;  t(1) = 0;  h = 0.1; n=1;
while t(n)<1
   n = n+1; t(n) = t(n-1) + h;
   yf(n) = yf(n-1) +  h*( -yf(n-1)^1.5 + 1);
end
%==== Modifed Euler
ym(1) = 10;  t(1) = 0;  h = 0.1; n=1;
while t(n)<1
   n = n+1;  t(n) = t(n-1) + h;
   ym(n) = ym(n-1) +  h*( - ym(n-1)^1.5 + 1);
   ymb = 1e10;
   while abs(ym(n) - ymb) > 0.00001
      ymb = ym(n);
    ym(n) = ym(n-1) ...
         + 0.5*h*( -ym(n)^1.5 - ym(n-1)^1.5 + 2);
   end
end
plot(t,yf,'--', t,ym, '-')
text(0.1, 0.7, ' ... Forward Euler    - Modified Euler', 'FontSize',[18])
text(0.7, -1.0, 't', 'FontSize',[18])
text(-0.15, 5, 'y', 'FontSize',[18])
axis([0,1.2, 0,10])
set(gca, 'FontSize',[18])
%print fig10D3.ps
