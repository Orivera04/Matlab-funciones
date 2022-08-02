% Script p3_5_07n.m; DTDP for max uf with vf=0 and (xf,yf) specified
% using DOPCN;                                           3/97, 7/27/02
%
N=40; s0=zeros(4,1); tf=1; name='dtdpcx'; nu=[-1.1753 2.0228 -1.2138];
optn=optimset('Display','Iter','MaxIter',500); c=pi/180; 
th=c*[103.7 102.4 100.8 99.00 96.89 94.46 91.60 88.17 83.93 78.60 ...
    71.79 63.17 52.59 40.32 27.21 14.40 2.93 -6.67 -14.36 -20.40 ...
   -25.15 -28.92 -31.96 -34.46 -36.55 -38.33 -39.86 -41.19 -42.35 ...
   -43.38 -44.29 -45.11 -45.84 -46.50 -47.10 -47.65 -48.14 -48.60 ...
   -49.02 -49.41]; p0=[th nu]; p=fsolve('dopcn',p0,optn,name,s0,tf);
[f,s,la0]=dopcn(p,name,s0,tf); th=p([1:N]); thh=[th th(N)]/c;
u=s(1,:); v=s(2,:); x=s(4,:); y=s(3,:); t=[0:1/N:1]; t1=[0:1/N:1-1/N];
% 
figure(1); clf; plot(x,y,x,y,'.'); grid; axis([-.04 .24 0 .21]);  
xlabel('x/at_f^2');  ylabel('y/at_f^2') 
%
figure(2); clf; subplot(211), zohplot(t1,th); grid 
ylabel('\theta (deg)'); subplot(212), plot(t,u,t,v,'r--'); grid
xlabel('t/t_f'); legend('u/at_f','v/at_f',2)


	


