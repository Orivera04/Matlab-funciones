% f9_13 same as L9_7
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.13; List 9.7')

clear, clf, hold off
gam = 1;
a=1;
b=1;
c=1; g = 1;
x1 = 0.01; y1 = 0.01; x2 = 0.95; y2 = 0.8;
for it = 1:20
A=zeros(4);
A(1,1)=1; A(1,2)=1; A(1,3)=1; A(1,4) = 0;
y(1) = -(a + b + c);
A(2,1) = exp(-g*x1); A(2,2) = exp(g*x1); A(2,3)=1;
    A(2,4) = a*(-x1)*A(2,1) + b*(x1)*A(2,2);
         y(2) = -(a*A(2,1) + b*A(2,2) + c - y1);
A(3,1) = exp(-g*x2); A(3,2) = exp(g*x2); A(3,3)=1;
    A(3,4) = a*(-x2)*A(3,1) + b*(x2)*A(3,2);
         y(3) = -(a*A(3,1) + b*A(3,2) + c - y2);
A(4,1) = exp(-g); A(4,2) = exp(g); A(4,3)=1;
    A(4,4) = a*(-1)*A(4,1) + b*(1)*A(4,2);
         y(4) = -(a*A(4,1) + b*A(4,2) + c - 1);
da=A\y';
a = a+da(1); b = b+da(2); c=c+da(3); g=g+da(4);
if sum(abs(da)) < 0.00001, break;end
end
x =0:0.05:1;
yy = a*exp(-g*x) + b*exp(g*x) + c;
plot(x,yy)
ylabel('y'), xlabel('x')

