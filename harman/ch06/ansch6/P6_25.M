% P6_25.M Plot Legendre polynomials
%  P1-P5 over [-1,1]
x=-1:0.01:1;
p1=x;
p2=1/2*(3*x.^2-1);
p3=1/2*(5*x.^3-3*x);
p4=1/8*(35*x.^4-30*x.^2+3);
p5=1/8*(63*x.^5-70*x.^3+15*x);
plot(x,p1,'-',x,p2,'*',x,p3,'+',x,p4,'--',x,p5)
legend('p1','p2','p3','p4','p5')
title('Legendre polynomials for n=1 to 5')
ylabel('Pn(x)')
xlabel('x')