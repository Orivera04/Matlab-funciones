% Script p1_3_13.m; min climbing turn radius (flg=1) & max climbing
% turn rate (flg=2) vs. gamma, w. corres. al, sg, and normalized V,
% using FMINCON; p=[V al ga];                        10/96, 6/27/02
%
flg=1; T=.2; alm=1/12; eta=1/2; c=180/pi; gam=6.79/c;
optn=optimset('Display','Iter','MaxIter',200); ga=gam*[0:.01:1];
N=length(ga); p=zeros(N+1,3); p(1,:)=[2.2 .25 .7]; lb=[0 0 0];
ub=[6 .5 pi/2];
for i=2:N+1,
 p(i,:)=fmincon('maxcltn1_f',p(i-1,:),[],[],[],[],lb,ub,...
   'maxcltn1_c',optn,ga(i-1),flg); end
V=p([2:N+1],1)'; al=p([2:N+1],2)'; sg=p([2:N+1],3)'; 
rr=tan(sg)./(V.^2.*cos(ga));
% Approx soln:
gam1=T-2*eta*alm; ga1=gam1*[0:.01:1]; un=ones(1,length(ga1));
mu=(T*un-ga1)/(2*eta*alm); sg1=.5*acos(un./(2*mu.^2-un));
al1=alm*un./sqrt(cos(2*sg1)); V1=sqrt(un./(al1.*cos(sg1)));
rr1=al1.*sin(sg1);
%
figure(1); clf; subplot(211), plot(c*ga,10*rr,c*ga,V,c*ga1,...
   10*rr1,'--',c*ga1,V1,'--',[c*gam c*gam],[0 4],'--',...
   c*gam,V(N),'o',c*gam,0,'o',c*gam1,V1(N),'o',c*gam1,0,'o');
grid; axis([0 7 0 4]); text(4.2,1.3,'10*l/r_min');
text(4.2,2.3,'V/sqrt(gl)')
text(.5,3.3,'T=.2, \alpha_m=1/12, \eta=1/2');
subplot(212), plot(c*ga,c*sg,c*ga,c*al,c*ga1,c*sg1,'--',c*ga1,...
   c*al1,'--',[c*gam c*gam],[0 50],'--',c*gam,c*alm,'o',c*gam,...
   0,'o',c*gam1,c*alm,'o',c*gam1,0,'o'); grid; axis([0 7 0 50])
ylabel('Deg'); xlabel('\gamma (deg)'); text(2.2,34,'\sigma')
text(2.2,17,'\alpha');
%
flg=2; p(1,:)=[3.5 .16 1];
for i=2:N+1,
 p(i,:)=fsolve('maxcltn',p(i-1,:),optn,ga(i-1),flg); end  
V=p([2:N+1],1)'; al=p([2:N+1],2)'; sg=p([2:N+1],3)'; 
psidot=tan(sg)./V;
% Approx. soln:
sg1=acos(un./sqrt(2*mu-un)); al1=alm*un./cos(sg1);
V1=sqrt(un./(al1.*cos(sg1))); psidot1=sqrt(2*alm*(mu-un));
%
figure(2); clf; subplot(211), plot(c*ga,10*psidot,c*ga,V,c*ga1,...
   10*psidot1,'--',c*ga1,V1,'--',[c*gam c*gam],[0 5],'--',c*gam,...
   V(N),'o',c*gam,0,'o',c*gam1,V1(N),'o',c*gam1,0,'o'); grid
axis([0 7 0 5]); text(4.1,1.4,'10*psidot*sqrt(l/g)')
text(5.1,4.2,'V/sqrt(gl)') 
text(.5,1.3,'T=.2, \alpha_m=1/12, \eta=1/2')
subplot(212), plot(c*ga,c*sg,c*ga,c*al,c*ga1,c*sg1,'--',c*ga1,...
   c*al1,'--',c*gam,c*alm,'o',c*gam,0,'o',c*gam1,c*alm,'o',...
   c*gam1,0,'o',[c*gam c*gam],[0 60],'--'); grid; axis([0 7 0 60])
ylabel('Deg'); xlabel('\gamma (deg)'); text(2.2,44,'\sigma')
text(2.2,15,'\alpha')


	