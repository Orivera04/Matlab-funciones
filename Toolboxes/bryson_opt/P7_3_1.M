% Script p7_3_1.m; min time paths to x=xf using gravity; x in 
% units of V^2/(2g), t in V/g;                      12/96, 7/23/02
%
c=pi/180; ga=c*[0:60]; x=(ga+sin(2*ga)/2)./(cos(ga)).^2;
T=ga./cos(ga); Y=(sin(ga)).^2./(ga+sin(ga).*cos(ga));
ga1=c*[60:90]; N=length(ga1); un=ones(1,N); 
rx=(cos(ga1)).^2./(ga1+sin(2*ga1)/2); rT=cos(ga1)./ga1;
Y1=(sin(ga1)).^2./(ga1+sin(ga1).*cos(ga1));
%
figure(1); clf; subplot(121),plot(x,ga/c); xlabel('2g(x_f-x)/V^2')  
grid; ylabel('\gamma (deg)'); subplot(122), plot(un-rx,ga1/c); 
grid; axis([1-1/6 1 60 90]); xlabel('1-V^2/(2g(x_f-x))')
%
figure(2); clf; subplot(121), plot(T,ga/c); ylabel('g(t_f-t)/V')
grid; xlabel('2g(x_f-x)/V^2'); axis([0 2.2 0 60]); subplot(122);
plot(un-rT,ga1/c); grid; xlabel('1-V^2/(2g(x_f-x))')
axis([1/2.2 1 60 90])
%
figure(3); clf; subplot(121),plot(x,Y); grid; ylabel('y)/(x_f-x)')
xlabel('2g(x_f-x)/V^2'); axis([0 6 0 .51]); subplot(122)
plot(un-rx,Y1); axis([5/6 1 .51 .64]); xlabel('1-V^2/(2g(x_f-x))')
grid