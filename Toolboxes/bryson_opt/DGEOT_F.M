function [f,th,ph]=dgeot_f(p,th0,thf,phf)                              
% Subroutine for Pb. 4.1.3; DVDP for min distance between two points on
% a sphere using FSOLVE on the EXACT EL eqns; p=estimate of optimal
% [be nu tf]; f=[Hu th-thf ph-phf Om]; s=[th ph]'; indpt. variable `t'
% is distance along path;                                 12/96, 6/2/98
%
c=pi/180; N=length(p)-3; be=p([1:N]); nuth=p(N+1); nuph=p(N+2);
tf=p(N+3); dt=tf/N; th(1)=th0; ph(1)=0;
%
% Forward sequence:
for i=1:N
   c=cos(be(i)); s=sin(be(i)); th(i+1)=th(i)+s*dt; 
   h2(i)=log(tan(th(i+1)/2+pi/4)); h1(i)=log(tan(th(i)/2+pi/4));
   if abs(s)>.0001, ph(i+1)=ph(i)+c*(h2(i)-h1(i))/s; 
     else ph(i+1)=ph(i)+dt*c/cos(th(i));
   end
end
%
% Backward sequence:
la=[nuth nuph]'; 
for i=N:-1:1
   c=cos(be(i)); s=sin(be(i)); st=1/cos(th(i)); st1=1/cos(th(i)+s*dt);
   if abs(s)>.0001, fs=[1 0; c*(st1-st)/s 1];
       fu=[c*dt; c^2*dt*st1/s-(h2(i)-h1(i))/s^2]; 
     else fs=[1 0; c*dt*sin(th(i))*st^2 1]; fu=dt*[c; -s/cos(th(i))];
   end;
   fd=[s; c*st1]; Hu(i)=la'*fu; Hd(i)=la'*fd; la=fs'*la;
end; 
Om=N; for i=1:N, Om=Om+Hd(i); end;
f=[Hu th(N+1)-thf  ph(N+1)-phf  Om]; 

