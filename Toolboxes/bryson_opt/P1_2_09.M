% Script p1_2_09.m; min radius helix & max turn rate for given glide
% angle; makes plots from explicit analytical solutions; 10/96, 6/27/02
%
% Part (d), plot min radius variables vs. gamma:
alm=1/12; eta=1/2; gamin=atan(2*eta*alm); c=180/pi; ga=[4.8:.1:12]/c; 
un=ones(1,length(ga)); mu=tan(ga)/(2*eta*alm); 
rr=alm*sqrt(mu.^2-un)./(cos(ga)).^2;
al=alm*sqrt(2*mu.^2-un); sg=.5*acos(un./(2*mu.^2-un));
V=sqrt((cos(ga))./(al.*cos(sg))); Vm=sqrt(cos(gamin)/alm);  
ga=ga*c; al=al*c; sg=sg*c; gam=gamin*c;
%
figure(1); clf; subplot(211), plot(ga,10*rr,'b',ga,V,'r--',gam,0,...
   'o',gam,Vm,'o',[gam gam],[0 4],'--'); axis([4 12 0 4]); grid 
legend('V','10/r'); title('Min Turn Radius vs. Glide Angle');
subplot(212), plot(ga,al,'b',ga,sg,'r--',gam,alm*180/pi,'o',gam,0,'o');
grid; axis([4 12 0 50]); hold on; plot([gam gam],[0 50],'--'); hold off
legend('\alpha','\sigma',2); xlabel('\gamma (deg)'); ylabel('Deg')  
%
% Part (e), plot max turn rate variable vs. gamma:
ga=[4.8:.1:25]/c; un=ones(1,length(ga)); mu=tan(ga)/(2*eta*alm);
chidot=sqrt(2*alm*(mu-un)./cos(ga)); al=alm*sqrt(2*mu-un);
sg=acos(un./sqrt(2*mu-un)); V=sqrt((cos(ga))./(al.*cos(sg)));
Vm=sqrt(cos(gamin)/alm); ga=ga*c; al=al*c; sg=sg*c; gam=gamin*c;
%
figure(2); clf; subplot(211), plot(ga,c*chidot,'b'); grid; hold on;
plot(ga,10*V,'r--',gam,0,'o',gam,10*Vm,'o',[gam gam],[0 60],'--');
hold off; axis([4 25 0 60]); title('Max Turn Rate vs. Glide Angle')
legend('Turn Rate (deg/unit time)','10*V',2)
subplot(212), plot(ga,al,'b',ga,sg,'r--',gam,alm*180/pi,'o',gam,0,'o');
grid; axis([4 25 0 80]); hold on; plot([gam gam],[0 80],'--');
hold off; legend('\alpha','\sigma',2); xlabel('\gamma (deg)')
ylabel('Deg')  

   
