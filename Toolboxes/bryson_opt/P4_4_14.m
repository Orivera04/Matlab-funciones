% Script p4_4_14.m; VDP to cross a river w. a parabolic current
% uc=uo*(1-y^2/h^2); uo in V, (x,y) in h, t in h/V; uo=1;
%                                                    2/97, 3/29/02
%
p0=[.5 3]; s0=[0 -1]'; optn=optimset('Display','Iter'); 
p=fsolve('zrmpt_f',p0,optn); opt=odeset('reltol',1e-4); tf=p(2); 
[t,s]=ode23('zrmpar',[0 tf],s0,opt); s=real(s); x=s(:,1); y=s(:,2);
th0=p(1); N=length(t); un=ones(N,1); secth=un/cos(th0)+un-y.^2;
th=real(acos(un./secth)); c=180/pi;
%
figure(1); clf; plot(x,y,x(1),y(1),'ro',x(N),y(N),'ro'); grid;
axis([-2/3 2/3 -1 1]); xlabel('x'); ylabel('y');
%
figure(2); clf; subplot(211),plot(t,c*th); grid; xlabel('V*t/h');
ylabel('\theta (deg)');

	