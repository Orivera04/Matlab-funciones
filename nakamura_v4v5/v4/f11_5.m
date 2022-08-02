%fig11_5
% Copyright S. Nakamura, 1995
figure(1)
set(gcf,'NumberTitle','off','Name','Figure11.5; List 1.5')

clear,clg, y0=0.1;
b(1)=5; c(1)=-2; s(1)=exp(-0.2) + y0;
for i=2:9
a(i)=-2; b(i)=5; c(i)=-2; s(i)=exp(-0.2*i);
end
a(10)=-2; b(10)=4.5; s(10)=0.5*exp(-2);
y=tri_diag(a,b,c,s,10)
plot(0:10,[y0,y])
xlabel('x');ylabel('y')

