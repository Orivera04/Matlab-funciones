% Script p4_4_05.m; min tf to spec. xf, yf, V0, ga0; (u,v) in V0,
% (x,y) in V0^2/a, t in V0/a;                        2/97, 3/29/02
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
 u=cg*un+t*cos(th(j)); v=sg*un+t*sin(th(j)); figure(1); plot(x,y);
 hold on; figure(2); plot(t,u,t,v,'r--'); hold on; 
end
figure(1); grid; axis([0 .52 -.125 .251]); plot(.45,0,'ro',0,0,'ro');
hold off; xlabel('ax/V0^2'); ylabel('ay/V0^2');
text(.05,-.025,'a*tf/V0=.485, ga0=13.8 deg, th=-100.0 deg');
text(.05,.125,'a*tf/V0=1.373, ga0=13.9 deg, th=-159.5 deg');
%
figure(2); grid; hold off; xlabel('at/V_0)'); 
ylabel('u/V_0) & v/V_0')