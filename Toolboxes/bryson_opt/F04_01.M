% Script f04_01.m; min tf to spec. xf, yf, V0, ga0; (u,v) in V0,
% (x,y) in V0^2/a, t in V0/a;                       2/97, 4/2/02
%
xf=.45; yf=0; c=pi/180; ga1=c*[13.8 13.9];
figure(1); clf; figure(2); clf;
for j=1:2; ga0=ga1(j); cg=cos(ga0); sg=sin(ga0);
   T=roots([1 0 -4 8*(xf*cg+yf*sg) -4*(xf^2+yf^2)]); T1=T;
 for i=1:4,
    if abs(imag(T(i)))>0; T(i)=1e9; elseif T(i)<0; T(i)=1e9; end
 end 
 tf(j)=real(min(T)); th(j)=atan2(yf-tf(j)*sg,xf-tf(j)*cg);
 t=tf(j)*[0:.01:1]; un=ones(1,101);
 x=cg*t+t.^2*cos(th(j))/2; y=sg*t+t.^2*sin(th(j))/2;
 u=cg*un+t*cos(th(j)); v=sg*un+t*sin(th(j)); figure(1); 
 plot(x,y); hold on; figure(2); plot(t,u,t,v,'r--'); hold on 
end
%
figure(1); grid; axis([0 .52 -.125 .251]); plot(.45,0,'ro',...
   0,0,'ro'); hold off; xlabel('ax/V_0^2'); ylabel('ay/V_0^2');
text(.05,-.025,'at_f/V_0=.485, \gamma_0=13.8 deg, \theta=-100.0 deg');
text(.05,.125,'at_f/V_0=1.373, \gamma_0=13.9 deg, \theta=-159.5 deg');
%print -deps2 \book_do\figures\f04_01
%
figure(2); grid; hold off; xlabel('at/V+0)'); ylabel('u/V_0) & v/V_0');