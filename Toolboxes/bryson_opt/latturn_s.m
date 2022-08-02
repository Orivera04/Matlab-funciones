function [f1,f2]=latturn_s(u,s,t,flg)
% Subroutine for latturn_f & latturn_c; s=[r th ph v ps ga]'; 
% units ft, rad, sec; m unknown - assume wing loading of 
% 30 lb/ft^2;                                        9/14/02
%
Om=2*pi/(24*60*60); A=2690; rho0=2.378e-3; be=4.2017e-5; 
g0=32.2; m=30*A/g0; r0=2.0903e7; CL0=-.2070; CLa=1.6756; 
CD0=7.854e-2; CDa=-.3529; CDa2=2.040; z=pi/180;
r=s(1); th=s(2); ph=s(3); v=s(4); ps=s(5); ga=s(6); 
cg=cos(ga); sg=sin(ga); ch=cos(ph); sh=sin(ph); cs=cos(ps);
ss=sin(ps); de=u(1); al=u(2); cd=cos(de); sd=sin(de);
cfv=Om^2*r*ch*(sg*ch-cg*sh*ss); cfp=-Om^2*r*sh*ch*cs/(v*cg);
cfg=Om^2*r*cg*(cg*ch+sg*sh*ss)/v;
cop=2*Om*(sg*ch*ss/cg-ss); cog=2*Om*ch*cs;
rho=rho0*exp(-be*(r-r0)); q=rho*v^2/2;
D=q*(CD0+CDa*al+CDa2*al^2)*A; L=q*(CL0+CLa*al)*A;
g=g0*(r0/r)^2;
%
if flg==1
   f1=[v*sg  v*cg*cs/(r*ch)  v*cg*ss/r  -D/m-g*sg+cfv ... 
       L*sd/(m*v*cg)-v*cg*cs*sh/(r*ch)+cfp+cop ...
      (L*cd+m*g*cg)/(m*v)+v*cg/r+cfg+cog]';
%elseif flg==2
%  f1=[ph; r-8e4-r0; v-2500; ga+5*z];
%elseif flg==3
end
    