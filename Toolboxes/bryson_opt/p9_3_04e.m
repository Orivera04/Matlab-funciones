% Script p9_3_04e.m; min fuel path for DIP using DP solution in
% form u=u(x,v,t); switch to u=0 when predicted time-to-go to
% (0,0) with coast-bang = 1-t;                         8/99, 3/31/02
%
figure(1); clf; v0=0; x0=[.025:.025:.25]; optn=odeset('Reltol',1e-4);
for i=1:10, x(1)=x0(i); v(1)=v0; u=-1;
   [t,s]=ode23('dip_mf',[0 1],[x0(i) v0]',optn); x=s(:,1); v=s(:,2);
   figure(1); plot(2*x,v); hold on
end 
%
clear x0; v0=.12; x0=[.03:.03:.21];
for i=1:7, x(1)=x0(i); v(1)=v0; u=-1;
   [t,s]=ode23('dip_mf',[0 1],[x0(i) v0]',optn); x=s(:,1); v=s(:,2);
   figure(1); plot(2*x,v); hold on 
end; plot(0,0,'ro'); hold off; axis([-.15 .6 -.6 .15]); grid 
axis('square'); ylabel('v/u_0t_f'); xlabel('2x/u_0t_f^2')



