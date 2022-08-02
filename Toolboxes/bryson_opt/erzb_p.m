function [x,y,t]=erzb_p(th0,xf)
% Erzberger's jet stream problem;                             8/16/98
%
th0=fsolve('erzb_f',th0,[],[],xf); th=th0*[1:-.01:-1]; N=length(th);
un=ones(1,N); t=un*tan(th0)-tan(th); x=.5*(un*asinh(tan(th0))...
   -asinh(tan(th))+tan(th)./cos(th)-un*tan(th0)/cos(th0))+t/cos(th0);
y=un/cos(th0)-un./cos(th); x=480*x; y=480*y;
%
figure(1); clf; subplot(211), plot(x,y); grid; axis([0 1000 0 300]);
xlabel('x (nmi)'); ylabel('y (nmi)'); 
title('Erzberger Jet Stream Problem');  text(620,220,'t_f=1.8469 hr');
text(160,220,'\theta_0=-\theta_f=42.72 deg');
text(420,120,'y_{max}=173.4');