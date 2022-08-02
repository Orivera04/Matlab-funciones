% Script p5_4_06a.m; undamped oscillator - ANALYTICAL SOLN; x=[y v]';
%                                                        4/97, 7/4/02
%
x0=[1 0]'; tf=[1 10]*pi; N=[50 100];
for i=1:2,
 T=tf(i); c=cos(T); s=sin(T); M=[(T*c-s)/2 T*s/2; T*s/2 -(T*c+s)/2];
 AB=M\x0; A=AB(1); B=AB(2); E=0; F=-A/2; t=T*[0:1/N(i):1];
 un=ones(1,N(i)+1); Tg=T*un-t; u=-A*sin(Tg)+B*cos(Tg);
 y=A*Tg.*cos(Tg)/2+B*Tg.*sin(Tg)/2+E*cos(Tg)+F*sin(Tg);
 v=A*Tg.*sin(Tg)/2-B*Tg.*cos(Tg)/2+(E-B/2)*sin(Tg);
 %
 figure(i); clf; subplot(211), t=t/(2*pi); plot(t,[v;y]); grid
 legend('y','v'); subplot(212), plot(t,u); grid; ylabel('u')
 xlabel('t/2\pi')
end 

