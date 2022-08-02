% Script e06_3_1.m; RRL for undamped oscillator;    7/92, 6/24/02
%
a=pi/16; ph=[cos(a) sin(a);-sin(a) cos(a)]; ga=[1-cos(a);sin(a)];
C=[1 0]; [n,d]=ss2tf(ph,ga,C,0,1); nr=[n(3) n(2) n(1)];
dr=[d(3) d(2) d(1)]; nrl=conv(n,nr); drl=conv(d,dr);
%
figure(1); clf; rlocus(nrl,drl); axis([-1.5 1.5 0 3]); grid
axis('square'); for i=1:91, xc(i)=cos(pi*(i-1)/90);
   yc(i)=sin(pi*(i-1)/90); end; hold on; plot(xc,yc); hold off
xlabel('Real(z)'); ylabel('Imag(z)')
%
K=[1 3 10 30 100 300 1000 3000 10000 30000];
R=rlocus(nrl,drl,K); z=[-1.02 -.98 0]; hold on; plot(R,'x');
plot(z,[0 0 0],'o'); hold off 