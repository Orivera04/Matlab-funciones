% Script e04_5_4.m; F4 min time climb using energy state approx
% (an initial value pb.);                                  9/96, 4/1/02
%
Wo=41998; S=530; g=32.2; rho=.002378; lc=2*Wo/(g*rho*S); Vc=sqrt(g*lc);
tc=lc/Vc; tf=280/tc; Vo=440/Vc; Eo=Vo^2/2; optn=odeset('reltol',1e-4);
s0=[Eo 1 0]'; [t,y]=ode23('f4_eclms',[0 tf],s0,optn); E=y(:,1);
W=y(:,2); N=length(t);
for i=1:N, V(i)=fminbnd('f4_edot',3,7,[],E(i),W(i));
   if V(i)<sqrt(2*E(i)); h(i)=E(i)-V(i)^2/2; else V(i)=sqrt(2*E(i));
   h(i)=0; end
end; V=V*Vc/1000; h=h*lc/1000; hf=65.60; Vf=.9687;
%
figure(1); clf; plot(V,h); hold on; V1=0:.1:2; for i=1:10, for j=1:21,
  h1(i,j)=i*10-V1(j)^2/(.0322*2); end; end
for i=1:10, plot(V1,h1(i,:)','r--'); end; plot(Vf,hf,'ro',.44,0,'ro');
hold off; grid; axis([0 2 -2 70]); xlabel('V (kft/sec)')
ylabel('h (kft)')  
