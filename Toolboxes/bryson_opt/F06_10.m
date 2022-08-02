% Script f06_10.m; recip. RL for undamped oscillator;
%                                        7/92, 4/2/02
%                  
a=pi/16; ph=[cos(a) sin(a);-sin(a) cos(a)];
ga=[1-cos(a); sin(a)]; C=[1 0];
[n,d]=ss2tf(ph,ga,C,0,1);
nr=[n(3) n(2) n(1)]; dr=[d(3) d(2) d(1)];
nrl=conv(n,nr); drl=conv(d,dr); sys=tf(nrl,drl);
K=[1 3 10 30 100 300 1000 3000 10000 30000];
z=[-1.02 -.98 0];
th=0:pi/90:pi; xc=cos(th); yc=sin(th);
%
figure(1); clf; rlocus(sys); hold on; rlocus(sys,K);
plot(z,[0 0 0],'o',xc,yc,'r--'); hold off 
axis([-1.5 1.5 0 3]); grid; xlabel('Real(z)');
ylabel('Imag(z)')
%print -deps2 \book_do\figures\f06_10 


