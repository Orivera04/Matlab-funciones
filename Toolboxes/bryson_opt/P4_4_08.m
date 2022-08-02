% Script p4_4_08.m; min tf to specified point with gravity, spec. 
% V0, ga0; (u,v) in V0, (x,y) in V0^2/a, t in V0/a;   2/97, 3/29/02
%
xf=.5; yf=.05; c=pi/180; ga0=c*45; g=1/3; cg=cos(ga0); sg=sin(ga0);
T=roots([1-g^2 4*g*sg -4-4*g*yf 8*(xf*cg+yf*sg) -4*(xf^2+yf^2)]); 
for i=1:4,
   if abs(imag(T(i)))>0; T(i)=1e9; elseif T(i)<0; T(i)=1e9; end
end; 
tf=real(min(T)); th=atan2(yf-tf*sg+g*tf^2/2,xf-tf*cg);
t=tf*[0:.01:1]; un=ones(1,101); x=cg*t+t.^2*cos(th)/2;
y=sg*t+t.^2*(sin(th)-g)/2; u=cg*un+t*cos(th); v=sg*un+t*(sin(th)+g);
%
figure(1); clf; subplot(211), plot(x,y,xf,yf,'ro',0,0,'ro'); grid
axis([0 .6 0 .45]); xlabel('ax/V_0^2'); ylabel('ay/V_0^2')
subplot(212), plot(t,u,t,v,'r--'); grid; xlabel('at/V_0)')
legend('u/V_0','v/V_0',3)

