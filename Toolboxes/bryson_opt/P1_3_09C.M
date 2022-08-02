% Script p1_3_09c.m; min radius helix & max turn rate for given glide
% angle using FMINCON; p=[V al sg]; flg=1 for min r; flg=2 for max turn
% rate;	                                                 10/96, 3/22/02
%
flg=1; alm=1/12; eta=1/2; optn=optimset('Display','Iter','MaxIter',300);
lb=[0 0 0]; ub=[8 .5 pi/2]; gamin=atan(2*eta*alm); c=180/pi;
ga=[gamin .09:.01:.21]; N=length(ga); p=zeros(N+1,3); J=zeros(N,1);
p(1,:)=[3.5 .1 .1]; 
for i=2:N+1,
 p(i,:)=fmincon('min_turn_f',p(i-1,:),[],[],[],[],lb,ub,...
     'min_turn_c',optn,ga(i-1),flg); end
p=p([2:N+1],:); for i=1:N, J(i)=min_turn_f(p(i,:),ga(i),flg); end
ga=c*ga; al=c*p(:,2); sg=c*p(:,3); gam=c*gamin;
%
figure(1); clf; subplot(211), plot(ga,-10*J,ga,p(:,1)); grid;
axis([4 12 0 4]); hold on; plot([gam gam],[0 4],'--'); hold off;
text(6.5,2.3,'V'); text(8.5,.8,'10/r'); 
title('Min Helix Radius vs. Glide Angle');
subplot(212), plot(ga,al,ga,sg,[gam gam],[0 50],'r--'); grid; 
axis([4 12 0 50]); text(8.5,16,'\alpha'); text(8.5,33,'\sigma');
xlabel('\gamma (deg)');	ylabel('Deg');  
%
flg=2; ga=[gamin .1:.02:.46];  N=length(ga); p=zeros(N+1,3);
J=zeros(N,1); p(1,:)=[5 .05 .3]; 
for i=2:N+1,
 p(i,:)=fmincon('min_turn_f',p(i-1,:),[],[],[],[],lb,ub,...
     'min_turn_c',optn,ga(i-1),flg); end
p=p([2:N+1],:); 
for i=1:N, J(i)=min_turn(p(i,:),ga(i),flg); end
ga=c*ga; al=c*p(:,2); sg=c*p(:,3);
%
figure(2); clf; subplot(211), plot(ga,-c*J,ga,10*p(:,1),[gam gam],...
   [0 60],'--'); grid; axis([4 25 0 60]); 
text(10.5,45,'Turn Rate (deg/unit time)'); text(18.5,22,'10*V');
title('Max Turn Rate vs. Glide Angle')
subplot(212), plot(ga,al,ga,sg,[gam gam],[0 80],'--'); grid;
axis([4 25 0 80]); text(12.5,20,'\alpha'); text(10.5,70,'\sigma');
xlabel('\gamma (deg)');	ylabel('Deg');  


   
