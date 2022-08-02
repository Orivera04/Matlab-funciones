function [f,xf,yf,xef,yef,tf,thf]=hochbps_f(X,w,el,xe0,ye0,ps);
% Subroutine for hochbps.m;                              3/8/02
%
tb=X(1); tf=X(2); cb=cos(tb); sb=sin(tb);  
thf=tf-2*tb; cf=cos(thf); sf=sin(thf);
xf=2*cb-1-cf; yf=2*sb+sf; cp=cos(ps); sp=sin(ps); 
xef=xe0+w*tf*sp; yef=ye0+w*tf*cp;
f=[xef-xf-el*sp; yef-yf-el*cp];
