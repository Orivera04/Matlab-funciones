function [f,xe0,ye0,xefs,yefs,xefb,yefb]=hochetf1(X,w,el,ts)
% Subroutine for hochetf.m                              2/27/02
%
tf=X(1); tb=X(2); ps=pi+(tf-3*tb)/2; cp=cos(ps); sp=sin(ps);
cs=cos(ts); ss=sin(ts); xfs=1-cs+(tf-ts)*ss; yfs=ss+(tf-ts)*cs;
xe0=xfs+(el-w*tf)*ss; ye0=yfs+(el-w*tf)*cs; thf=tf-2*tb; 
cb=cos(tb); sb=sin(tb); cf=cos(thf); sf=sin(thf);
xfb=2*cb-1-cf; yfb=2*sb+sf;
xe0b=xfb+(el-w*tf)*sp; ye0b=yfb+(el-w*tf)*cp;
f=[xe0b-xe0; ye0b-ye0]; xefs=xe0+w*tf*ss; 
yefs=ye0+w*tf*cs; xefb=xe0+w*tf*sp; yefb=ye0+w*tf*cp;
