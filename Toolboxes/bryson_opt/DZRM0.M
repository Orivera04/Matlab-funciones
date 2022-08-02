function [f1,f2]=dzrm0(u,s,dt,t,flg)                
% Subroutine for p2_2_2 & 2_5_2; DVDP for max range with uc=Vo*y/h;
% a Zermelo Pb.;                                        2/97, 6/23/98
%
x=s(1); y=s(2); th=u; si=sin(th); c=cos(th);
if flg==1, f1=[x+dt*(c+y)+dt^2*si/2; y+dt*si];
elseif flg==2, f1=x; f2=[1 0];
elseif flg==3, f1=[1 dt; 0 1]; f2=dt*[-si+dt*c/2; c]; 
end

