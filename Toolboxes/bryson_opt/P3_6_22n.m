% Script p3_6_22n.m; A/C max final altitude glide w. spec. Vf,gaf
% using FOPCN; s=[V ga h]';                              8/15//02
%
name='gldc'; N=40; tf=30; t=tf*[0:1/N:1]; s0=[4 0 0]';
nu=[4.5535 2.2819]; c=180/pi;
al0=[6.2743 5.5710 5.1718 5.0349 5.1137 5.3819 5.8130 6.3644 ...
     6.9722 7.5572 8.0552 8.4237 8.6554 8.7763 8.8084 8.7890 ...
     8.7463 8.7036 8.6761 8.6757 8.7044 8.7612 8.8382 8.9205 ...
     8.9834 8.9957 8.9161 8.6926 8.3041 7.7398 7.0380 6.2829 ...
     5.5711 4.9856 4.5776 4.3808 4.3950 4.6304 5.1156 5.9196 ...
     7.1826]/c; p0=[al0 nu]; 
optn=optimset('Display','Iter','MaxIter',500); 
p=fsolve('fopcn',p0,optn,name,s0,tf);
[f,s,la0]=fopcn(p,name,s0,tf); N1=N+1; al=p([1:N1]); 
V=s(1,:); ga=s(2,:); h=s(3,:); ke=V.^2/2;   
%
figure(1); clf; plot(ke,h,8,h(N1),'ro',8,0,'ro'); grid
axis([0 10 -9 5]); axis('square'); xlabel('V^2/2gl')
ylabel('h/l')
%
figure(2); clf; subplot(211), plot(t,V,[0 tf],2.61*[ 1 1],'r--'); 
grid; ylabel('V'); subplot(212), plot(t,c*ga,[0 tf],-c*.0964*[1 1],...
   'r--'); grid; ylabel('\gamma (deg)'); xlabel('t*sqrt(g/l)')
%
figure(3); clf; subplot(211), plot(t,h,[0 tf],[4.58 -2.97],...
    'r--',[0 0],[0 4.58],'r--',tf*[1 1],[-2.97 -7.55],'r--');
grid; ylabel('h'); subplot(212), plot(t,c*al,[0 tf],.1457*c*[1 1],...
   'r--'); grid; ylabel('\alpha (deg)'); xlabel('t*sqrt(g/l)')