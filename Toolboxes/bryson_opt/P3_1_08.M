% Script p3_1_08.m; DTDP for max xf with gravity and 
% spec. yf, V0, ga0; (u,v,V0) in a*tf, (x,y) in a*tf^2; 
%                                          2/97, 3/30/02
%
N=20; u0=.5/sqrt(2); v0=u0; yf=0; g=1/3;
th=asin(g+2*(yf-v0)); xf=u0+cos(th)/2; t=[0:1/N:1];
x=t*u0+t.^2*cos(th)/2; y=t*v0+t.^2*(sin(th)-g)/2;
%
figure(1); clf; plot(x,y,x,y,'b.',xf,0,'ro',0,0,'ro'); 
grid; xlabel('x/at_f^2'); axis([0 .9 -.75*.4 .75*.5]); 
ylabel('y/at_f^2');
	