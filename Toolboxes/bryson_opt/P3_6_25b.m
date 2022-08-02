% Script p3_6_25b.m; 727 max hf climbing turn with (Vf,psf) spec. using 
% FOPCB; s=(V,ga,ps,h,x,y)'; u=[al,sg]';                  3/94, 5/28/02
%
sf=[.6 .0836 1.5710 .5134 1.6041 .9357]; nu0=[.4887 .0366]; nc=2;
p=[sf nu0]; name='maxalt'; tf=2.4; s0=[1 0 0 0 0 0]';
optn=optimset('Display','Iter','MaxIter',100); 
p=fsolve('fopcb',p,optn,name,s0,tf,nc);[f,t,y]=fopcb(p,name,s0,tf,nc);
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S);
Vc=sqrt(g*lc); tc=lc/Vc; t=tc*t; c=180/pi; V=y(:,1); ga=y(:,2);
ps=y(:,3); h=lc*y(:,4); x=lc*y(:,5); y1=lc*y(:,6); lv=y(:,7); lg=y(:,8);
lp=y(:,9); cga=cos(ga); al1=12*pi/180; a0=.2476; a1=-.04312; a2=.008392;
th=a0+a1*V+a2*V.^2; N1=length(V); b1=-.08617; b2=1.996; c0=.1667; 
c1=6.231; alc=zeros(1,N1); sg=atan(lp./(cga.*lg)); cs=cos(sg);
ss=sin(sg); ep=2/c; 
for i=1:N1, al=8/c; z=1;
  while abs(z)>1e-7, ca=cos(al+ep); sa=sin(al+ep);
   if al<al1, c2=0; else c2=-21.65; end
   cda=b1+2*b2*al; cla=c1+2*c2*(al-al1);
   z=lv(i)*(-th(i)*sa-V(i)^2*cda)+(lg(i)*cs(i)+...
      lp(i)*ss(i)/cga(i))*(th(i)*ca+cla)/V(i);
   za=lv(i)*(-th(i)*ca-V(i)^2*2*b2)+(lg(i)*cs(i)+...
      lp(i)*ss(i)/cga(i))*(-th(i)*sa+2*c2)/V(i);
   al=al-z/za; 
  end; alc(i)=al; 
end; V=Vc*V;  
%
figure(1); clf; plot3(x,y1,h,x,y1,zeros(1,N1),'r--'); grid
view(-80,15); axis(1e3*[0 6 0 3.5 0 3]); xlabel('x (ft)') 
ylabel('y (ft)'); zlabel('h (ft)')
%
figure(2); clf; subplot(211), plot(t,c*alc,t,c*sg); grid
legend('\alpha','\phi',2); hold on; plot([0 24],[29.5 29.5],'r--');
plot([0 24],[11.8 11.8],'r--'); hold off %axis([0 25 0 35]);     
ylabel('deg'); subplot(212), plot(t,h); grid %axis([0 25 0 1800]);
xlabel('Time'); ylabel('Altitude (ft)')
%
figure(3); clf; subplot(211); plot(V,h,[280 280],[425 875],'r--'); 
grid; axis([180 360 0 1800]); hold on; Vo=1*Vc; dV=(Vo-280)/20;
V1=[Vo:-dV:280]; for i=1:21, h1(i)=(Vo^2/2-V1(i)^2/2)/32.2; end
plot(V1,h1,'r--'); Vf=.6*Vc; dV=(280-Vf)/20; V1=[Vf:dV:280]; hf=1660;
for i=1:21, h1(i)=hf+(Vf^2/2-V1(i)^2/2)/32.2; end; plot(V1,h1,'r--',...
   Vo,0,'o',Vf,hf,'o'); hold off; xlabel('Velocity (ft/sec)')
ylabel('Altitude (ft)'); subplot(212), plot(t,V); grid 
ylabel('V (ft/sec)'); xlabel('Time')
%
figure(4); clf; plot(x,y1); grid; xlabel('x (ft)'); ylabel('y (ft)')
   
   

	
	
	