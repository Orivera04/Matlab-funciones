% Script p8_5_3.m; numerical solution for min dist on a sphere
% using FOP0N2; s=[d th]'; t=ph=longitude difference;
% (see B & H, Example 6.3.2, p.186);                   8/10/02
%
global thf sth K; c=pi/180; thf=0; sth=1e3; name='geo0y'; 
phf=170*c; tol=1e-4; mxit=5;
% Analytical expression for feedback gain for sy==>infinity:
N=30; ph1=phf*[0:1/N:1-1/N]; un=ones(1,N);
Kth=un./tan(un*(phf+1/sth)-ph1);
%
figure(1); clf;
th0=[2*c 0]; for i=1:2
  tu=[0 phf]'; be0=[0 0]'; s0=[0 th0(i)]'; 
  [ph,be,s,K,Hu,Huu]=fop0n2(name,tu,be0,s0,phf,tol,mxit); th=s(:,2);
  subplot(311), plot(ph/c,th/c,0,th0(i)/c,'ro',phf/c,0,'ro'); 
  axis([0 170 -2 13]); ylabel('Latitude \theta (deg)'); hold on
  subplot(312), plot(ph/c,be/c); grid; axis([0 170 -30 0])
  ylabel('Heading \beta (deg)'); axis([0 phf/c -15 15]);
  hold on; subplot(313), plot(ph/c,K(:,2),ph1/c,Kth,'.'); 
  legend('Numerical','Analytical',2); ylabel('K\theta')
  xlabel('Longitude Diff. (deg)'); axis([0 phf/c -8 8]); 
end
subplot(312), grid; hold off; subplot(313), grid 
%
% A neighboring optimum path:
global phn ben thn; phn=ph; ben=be; thn=th; 
optn=odeset('RelTol',1e-4); s0=[0 th0(1)]'; 
[ph1,s1]=ode23('geo0ys',[0 phf],s0,optn); th1=s1(:,2);  
figure(1); subplot(311), plot(ph1/c,th1/c,'r.'); grid; hold off


