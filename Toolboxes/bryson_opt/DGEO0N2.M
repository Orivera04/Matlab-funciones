function [f1,f2,f3,f4,f5]=dgeo0n2(be,s,dt,t,flg)           
% Subroutine for Pb. 8.4.3; min distance path from Sydney to SFO; 
% s=[d,th]' where d=distance along path, th=latitude, be=heading angle
% north of east; t=longitude (rad);  	                12/92, 6/12/02
%
thf=37.8*pi/180; d=s(1); th=s(2); cb=cos(be); sth=2e3; sb=sin(be);
tb=tan(be); ct=cos(th); st=sin(th);
if flg==1
 f1=s+dt*(ct/cb)*[1; sb];	               
elseif flg==2
 f1=d+sth*(th-thf)^2/2;
 f2=[1 sth*(th-thf)];
 f3=[0 0; 0 sth];                                         % f3 = phiss
elseif flg==3
 f1=[1 -dt*st/cb; 0 1-dt*st*tb];
 f2=dt*(ct/cb^2)*[sb; 1];
 f3=-dt*(ct/cb)*[0 0; 0 1; 0 0; 0 sb];                      % f3 = fss
 f4=-dt*(st/cb^2)*[0 sb; 0 1];                              % f4 = fsu
 f5=dt*(ct/cb^3)*[cb^2+2*sb^2; 2*sb];                       % f5 = fuu
end
