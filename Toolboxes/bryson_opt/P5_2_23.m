% Script p5_2_23.m; bicycle turn; x=[ph p ps de]'; xdot=Ax+Bu; 2J=
% ef'*Qf*ef+int(u^2)dt; ef=Mf*xf-ps; indpt. variable is distance in
% units of l=wheelbase; c=V^2/(gl), a=mlh/I, e=b/l; V=velocity; h=height
% of c.m (bike plus rider) above ground; m=mass of bike plus rider;
% I=roll MOI of bike plus rider about axis through points where wheels 
% touch ground (I=approx 4mh^2/3), e=approx 1/2; system has RHP com-
% promise zeroes;                                         10/97, 6/30/02
%
flg=2; V=(12*88)/60; l=40/12; h=36/12; b=20/12; a=.75*l/h; g=32.2;
psf=pi/2; c=V^2/(g*l); e=b/l; A=[0 1 0 0; a/c 0 0 -a; 0 0 0 1; 0 0 0 0];
B=[0 -a*e 0 1]'; N=zeros(4,1); R=1; tf=25; s0=[0 0 0 0]'; c=180/pi; 
Q=diag([.1 0 0 0]); Mf=eye(4); Qf=1e4; psi=[0 0 psf 0]'; Ns=100; 
tol=1e-4; 
if flg==1, [s,u,t]=tlqs(A,B,Q,N,R,tf,s0,Mf,Qf,psi,Ns);
   ph=c*s(1,:); ps=c*s(3,:); de=c*s(4,:);
elseif flg==2, [s,de,t,tk,K]=tlqsr(A,B,Q,N,R,tf,s0,Mf,Qf,psi,tol); 
   ph=c*s(:,1); ps=c*s(:,3); de=c*s(:,4);
end
%
figure(1); clf; subplot(311), plot(t,ph,[0 tf],(b*c*psf/tf)*[1 1],...
   '--'); grid; ylabel('\phi (deg)'); title('Bicycle Turn')
subplot(312), plot(t,ps,[0 tf],[0 c*psf],'--'); axis([0 25 -10 100]);
grid; ylabel('\psi (deg)'); subplot(313),plot(t,de,[0 tf],...
  (c*psf/tf)*[1 1],'--'); grid; xlabel('Distance/l')
ylabel('\delta (deg)')




  