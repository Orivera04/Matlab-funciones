% Script p1_2_13.m; min climbing turn radius and max climbing
% turn rate with corresponding p=(V,al,sg) vs. ga, using
% FSOLVE; also plots approx. soln. of Pb. 1.2.14; 10/96, 3/25/02
% NOTE: version 6 FSOLVE gives poor results; version 5 (used here)
% is OK.
%
T=.2; alm=1/12; eta=1/2; c=180/pi; gam=6.79/c; optn(14)=100; 
ga=gam*[0:.1:.9 .91:.02:.99]; N=length(ga);
% Approx. min climb turn radius:
gam1=T-2*eta*alm; ga1=gam1*[0:.1:.9 .91:.02:.99]; 
un=ones(1,length(ga1)); mu=(T*un-ga1)/(2*eta*alm); 
sg1=.5*acos(un./(2*mu.^2-un)); al1=alm*un./sqrt(cos(2*sg1)); 
V1=sqrt(un./(al1.*cos(sg1))); rr1=al1.*sin(sg1);  
% Exact soln.:
flg=1; p=zeros(N,3); p(1,:)=[V1(1) al1(1) sg1(1)];
for i=2:N,
 p(i,:)=fsolve('maxcltn',p(i-1,:),optn,[],ga(i),flg); end
V=p(:,1)'; al=p(:,2)'; sg=p(:,3)'; rr=tan(sg)./(V.^2.*cos(ga));
ga=c*ga; ga1=c*ga1; gam=c*gam; gam1=c*gam1; al=c*al; al1=c*al1;
sg=c*sg; sg1=c*sg1;
%
figure(1); clf; subplot(211), plot(ga,10*rr,ga,V,'r',...
  ga1,10*rr1,'b--',ga1,V1,'r--',[gam gam],[0 4],'b--');
grid; axis([0 7 0 4]); text(4.2,1.3,'10*l/r_{min}'); 
text(4.2,2.3,'V'); text(.5,3.3,'T=.2, \alpha_m=1/12, \eta=1/2');
subplot(212), plot(ga,sg,ga,al,'r',ga1,sg1,'b--',ga1,al1,...
  'r--',[gam gam],[0 50],'b--'); grid; axis([0 7 0 50]) 
ylabel('Deg'); xlabel('\gamma (deg)') 
text(2.2,34,'\sigma'); text(2.2,17,'\alpha')
%
% Approx. max turn rate:
sg1=acos(un./sqrt(2*mu-un)); al1=alm*un./cos(sg1);
V1=sqrt(un./(al1.*cos(sg1))); chidot1=sqrt(2*alm*(mu-un));
% Exact soln.:
flg=2; p(1,:)=[V1(1) al1(1) sg1(1)]; ga=ga/c;
for i=2:N,
 p(i,:)=fsolve('maxcltn',p(i-1,:),optn,[],ga(i),flg); end  
V=p(:,1)'; al=p(:,2)'; sg=p(:,3)'; chidot=tan(sg)./V;
ga=c*ga; al=c*al; al1=c*al1; sg=c*sg; sg1=c*sg1;
%
figure(2); clf; subplot(211), plot(ga,10*chidot,ga,V,'r',...
  ga1,10*chidot1,'b--',ga1,V1,'r--',[gam gam],[0 5],'b--'); 
grid; axis([0 7 0 5]); text(4.1,1.4,'10*dot\chi');
text(5.1,4.2,'V'); text(.5,1.3,'T=.2, \alpha_m=1/12, \eta=1/2')
subplot(212), plot(ga,sg,ga,al,'r',ga1,sg1,'b--',ga1,al1,...
  'r--',[gam gam],[0 60],'b--'); grid; axis([0 7 0 60])
ylabel('Deg'); xlabel('\gamma (deg)'); text(2.2,44,'\sigma')
text(2.2,15,'\alpha');

	