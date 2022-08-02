% Script f01_10.m; calculates and plots Pb. 1.2.7e, max velocity of
% sailboat vs. heading; plot from analytical solution for mu=1;
%y=[V,Wr,alpha,theta,psi];                           10/96, 3/25/02
%
c=pi/180; ps=[2:2:178]*c; n=length(ps); th1=zeros(3,n);
for i=1:n, a=ps(i); z=[4 -2*sin(2*a) -4+(sin(a))^2  2*sin(2*a)];
th1(:,i)=acos(roots(z)); end; tho=sort(th1); tho=tho([1 2],:);
th=[tho(2,[1:27]) tho(1,[28:89])]; th=[pi/2 th 0]; ps=[0 ps pi];
wr=sin(ps)./sin(2*th); wr(1)=.5; wr(91)=0; V=wr.*sin(th);
Vm=.593; psm=73.3*c; Vmx=Vm*sin(psm); Vmy=Vm*cos(psm);
%
figure(1); clf; plot(V.*sin(ps),-V.*cos(ps)); grid; 
axis([-.7 .7 -1.02 .4 ]); axis('square'); hold on; 
plot(-V.*sin(ps),-V.*cos(ps),0,0,'o',0,-1,'o',Vmx,-Vmy,'o');
plot([0 Vmx],[-1 -Vmy],'r--',[0 Vmx],[ 0 -Vmy],'r--'); 
plot([0 0],[-1 0],'r--'); text(.26,-.01,'V');
plot([.2 Vmx],[-.3 -Vmy]); text(-.15,-.7,'W'); text(.3,-.7,'W_R');
be1=pi-16.7*c; be2=pi+19.4*c; dbe=be2-be1; be3=[be1:dbe/10:be2];
x1=Vmx+.22*cos(be3); y1=-Vmy+.22*sin(be3); plot(x1,y1,':');
be1=pi+19.4*c; be2=pi+(19.4+36.1)*c; dbe=be2-be1; 
be3=[be1:dbe/10:be2]; x1=Vmx+.18*cos(be3); y1=-Vmy+.18*sin(be3); 
plot(x1,y1,':'); text(.26,-.18,'\theta'); text(.34,-.32,'\alpha');
be1=2*pi-16.7*c; be2=1.5*pi; dbe=be2-be1; be3=[be1:dbe/10:be2]; 
x1=.2*cos(be3); y1=.2*sin(be3); plot(x1,y1,':');
text(.05,-.1,'\psi'); text(-.5,-.9,'\mu = 1'); axis('off');
print -deps2 \book_do\figures\f01_10




