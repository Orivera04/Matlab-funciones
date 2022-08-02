% Script p1_2_18.m; min weight inverted simple truss WITH LOAD AT
% BOTTOM POINT, analytical solution; a variation of Pb. 1.2.17 which 
% has 0 load in the central member;                   10/96, 5/13/98
%
bc=sqrt(6)/pi; Wc=6*sqrt(2)/pi^2; thc=atan(sqrt(2)); c=180/pi;
Jc=2*Wc/(sin(2*thc))+2*bc^2;
%
% b<bc (members 3 & 4 slender columns):
th1=[55:1:85]/c; th1=[atan(sqrt(2)) th1]; un=ones(1,length(th1));
b21=bc^2*un./((tan(th1).^2)-un); W1=b21.^2.*tan(th1)/bc^2;
J1=2*W1./sin(2*th1)+2*b21;
%
% b>bc (members 3 & 4 short columns):
th=[1 1]*thc; W=[Wc 3]; b2=[1 1]*bc^2/2+W/(2*sqrt(2)); 
J=2*W./sin(2*th)+2*b2; 
%
figure(1); clf; subplot(211), plot(W1,c*th1,'b',W,c*th,'b',...
   W1,10*J1,'r--',W,10*J,'r--',[Wc Wc],[0 90],'r--',0,90,'bo'); 
grid; axis([0 3 0 90]); text(.55,70,'\theta (deg)');
text(.6,10,'10*J');
subplot(212), plot(W1,b21/bc^2,'b',W,b2/bc^2,'b',[Wc Wc],...
   [0 2.5],'r--'); grid; xlabel('W'); ylabel('b^2/bc^2');