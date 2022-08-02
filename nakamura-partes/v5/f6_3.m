% f6_3
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 6.3')

clear , clf
c=[0, 1,0, 2, 0, 16,0,272,7936,0];
n=length(c);
n=8;
for m=1:30
x=(m-1)*0.05;
g=0;
fact=1;
for k=1:n-1  
fact=fact/k;
g=g+x.^k * c(k+1)*fact;
end
gs(m)=g;
end
mm=1:30;
xx = (mm-1)*0.05;
plot(xx, -gs+ tan(xx))
yy=-gs+ tan(xx);
text(xx(25)+0.05, yy(25), ['k=', num2str(n)] )
hold on
n=6;
for m=1:30
x=(m-1)*0.05;
g=0;
fact=1;
for k=1:n-1  
fact=fact/k;
g=g+x.^k * c(k+1)*fact;
end
gs(m)=g;
end
mm=1:30;
xx = (mm-1)*0.05;
plot(xx,- gs+ tan(xx), '--')
yy=-gs+ tan(xx);
text(xx(22)-0.03, yy(22), ['k=', num2str(n)] )
hold on
n=4;
for m=1:30
x=(m-1)*0.05;
g=0;
fact=1;
for k=1:n-1
fact=fact/k;
g=g+x.^k * c(k+1)*fact;
end
gs(m)=g;
end
mm=1:30;
xx = (mm-1)*0.05;
plot(xx, -gs+ tan(xx), '-.')
yy=-gs+ tan(xx);
text(xx(19)-0.1, yy(19), ['k=', num2str(n)] )
axis([0 1.6 -0.5 0.5])
xlabel('x')
ylabel('Error of expansion:   gk(x) - tan(x)')
%print fig6_3.ps 



