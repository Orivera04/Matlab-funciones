%  alt_2_3.m
%  plot two quantile sets on the same axes

load singer

x = sort(Tenor_1);
[m n] = size(x);
if m>1
   n = m;
end
f = ((1:n)-0.5)/n;

x2 = sort(Bass_2);
[m n] = size(x2);
if m>1
   n = m;
end
f2 = ((1:n)-0.5)/n;

hg = plot(f2,x2,'--x',f,x,'-o');
legend(hg,char({'Bass_2';'Tenor_1'}),4);
xlabel('f-value')
ylabel('Height (inches)')

