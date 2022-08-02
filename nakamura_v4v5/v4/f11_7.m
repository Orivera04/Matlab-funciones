%fig11_7
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure 10.7; List 11.2')

clear,clf
ni=200;
h=10/ni; h2inv = 1/h/h; hinv=1/h;
eta=h*(1:ni); f=ones(1,ni);
for k=1:9
  for i=1:ni
    a(i) = h2inv - 0.25*f(i)*hinv;
    b(i) = -2*h2inv;
    c(i) = h2inv + 0.25*f(i)*hinv;
    s(i)=0;
  end
  s(ni)=-c(ni);
  g=tri_diag(a,b,c,s,ni);
  f(1)=0.5*g(1)*h;
  for i=2:ni
    f(i)=0.5*(g(i) + g(i-1))*h+f(i-1);
  end
end
if k==1 hold on, end
axis([0,10,0,2])
fdd0 = (-g(2) + 4*g(1))/2/h;
fdd(1)= (g(2)-0)/h/2;
for i=2:ni-1
fdd(i)=(g(i+1)-g(i-1))/h/2;
end
fdd(ni) = (3*g(ni) - 4*g(ni-1) + g(ni-2))/h/2;
plot([0,eta],[0,g],[0,eta],[fdd0,fdd])
%[[0,eta(20:20:ni)]', [0,g(20:20:ni)]', [fdd0,fdd(20:20:ni)]'];
text(2.2, 0.63, 'f`=g', 'Fontsize', [18])
h=text(2.2, 0.3, 'f``=g`', 'Fontsize', [18]);
text(5, -0.05, 'h', 'FontName', 'Symbol','Fontsize',[18])
text(-1.0,0.4, 'f` and f``', 'Fontsize',[18],'Rotation',[90])

