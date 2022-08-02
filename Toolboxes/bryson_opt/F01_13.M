% Script f01_13.m; max gamma and max climb rate and corresponding
% alpha and V vs. T, using FSOLVE; also plots approx. soln. of  Pb.
% 1.2.12; p=[V al ga];                               10/96, 3/25/02
% NOTE: Version 6 FSOLVE gives poor results; version 5 is OK
%
alm=1/12; eta=1/2; T=[0:.05:.9 .95 .99]; N=length(T); 
% Soln. for small T, al, ga:
un=ones(1,N); ga1=T-2*eta*alm*un; V1=un./sqrt(2*eta*alm);
rc1=V1.*sin(ga1);
% Exact soln. using FSOLVE:
optn(14)=100; %optn=optimset('MaxIter',100); 
flg=1; p=zeros(N,3); p(1,:)=[V1(1) alm ga1(1)]; c=180/pi;
for i=2:N,
 p(i,:)=fsolve('maxclmb',p(i-1,:),optn,[],T(i),flg); end  
V=p(:,1); al=p(:,2); ga=p(:,3); rc=V.*sin(ga);
ga=c*ga; al=c*al; ga1=c*ga1; al1=c*alm*un;
%
figure(1); clf; subplot(211), plot(T,ga,T,al,'r',T,ga1,'b--',...
    T,al1,'r--'); grid; axis([0 .9 -20 60]); ylabel('Deg'); 
text(.12,45,'\alpha_m=1/12'); text(.36,25,'\gamma_{max}');
text(.62,12,'\alpha'); text(.13,34,'\eta=1/2')
subplot(212), plot(T,V,T,rc,'r',T,V1,'b--',T,rc1,'r--'); 
grid; axis([0 .9 -1 4]); xlabel('T/mg'); text(.52,2.5,'V');
text(.25,1.5,'hdot')
%
% Soln. for small T, ga, al:
al1=sqrt(T.*T/(4*eta^2)+3*alm^2*un)-T/(2*eta);
ga1=T-eta*(al1+alm^2*un./al1); V1=un./sqrt(al1); rc1=ga1./sqrt(al1);
% Exact soln.:
flg=2; p(1,:)=[V1(1) al1(1) ga1(1)];
for i=2:N,
 p(i,:)=fsolve('maxclmb',p(i-1,:),optn,[],T(i),flg); end  
V=p(:,1); al=p(:,2); ga=p(:,3); rc=V.*sin(ga);
ga=c*ga; al=c*al; ga1=c*ga1; al1=c*al1;
%
figure(2); clf; subplot(211), plot(T,ga,T,al,T,ga1,'--',T,al1,'--');
grid; axis([0 .9 -10 40]); ylabel('Deg'); text(.42,24,'\gamma'); 
text(.62,5,'\alpha'); subplot(212), plot(T,V,T,rc,T,V1,'--',T,...
    rc1,'--'); grid;  axis([0 .9 -2 10]); xlabel('T/mg');
text(.18,7,'V'); text(.25,3,'hdot_{max}')


