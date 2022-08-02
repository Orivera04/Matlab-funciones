function [f,xf,yf,xef,yef,tf,thf]=hochb_f(X,w,el,xe0,ye0);
% Subroutine for hochb.m;                       2/28/02
%
tb=X(1); ps=X(2); tf=3*tb+2*ps-2*pi; thf=tf-2*tb;
cp=cos(ps); sp=sin(ps); cf=cos(thf); sf=sin(thf);
cb=cos(tb); sb=sin(tb); xf=2*cb-1-cf; yf=2*sb+sf;
xef=xe0+w*tf*sp; yef=ye0+w*tf*cp;
f=[xf+el*sp-xef; yf+el*cp-yef];