% Script p8_7_4.m; min dist on torus showing conjugate point;
%                                                   3/94,  7/25/02
%
tf=[2 2.1 2.1 2.25 2.4 3.2]; s01=[.2 .4 .6 .8 1 1.25];
%
figure(1); clf;  
for i=1:6, s0=[0 s01(i)]'; 
   [ph,s]=ode23('torus',[0 tf(i)],s0); th=s(:,1)/pi; ph=ph/pi; 
   plot(ph,th,ph,-th,'b'); hold on
end
plot(.6325,0,'ro',[0 .6325],[0 0],0,0,'ro',[.6325 1],[0 0],'r-.');
hold off; axis([0 1 -1 1]); grid; xlabel('Longitude/pi')
ylabel('Latitude/pi'); text(.67,.78,'\beta_o=1.25 rad')
text(.6,.46,'1.0'); text(.54,.37,'.8'); text(.47,.31,'.6')
text(.41,.23,'.4'); text(.36,.14,'.2'); text(.32,.04,'0') 
text(.84,.1,'Outer'); text(.82,-.1,'Equator')
text(.14,.9,'Inner Equator'); text(.14,-.9,'Inner Equator') 
text(.61,.21,'Conj. Pt.'); title('Min Distance on Torus, a/b=1.5')
	
	