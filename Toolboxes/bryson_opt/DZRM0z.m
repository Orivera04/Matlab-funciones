function [f1,f2]=dzrm0z(u,s,dt,t,flg)                
% Subroutine for p2_2_2z; DVDP for max range with uc=V*y/h & spec. yf;
% a Zermelo Pb.;                                         2/97, 9/10/02
%
x=s(1); y=s(2); th=u; si=sin(th); co=cos(th);
sf=1e2; yf=1;
if flg==1
    f1=[x+dt*(co+y)+dt^2*si/2; y+dt*si];
elseif flg==2
    f1=x-sf*(y-yf)^2/2; 
    f2=[1 -sf*(y-yf)];
elseif flg==3
    f1=[1 dt; 0 1];
    f2=dt*[-si+dt*co/2; co]; 
end

