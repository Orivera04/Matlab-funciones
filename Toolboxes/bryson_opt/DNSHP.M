function [f1,f2]=dnshp(u,s,dt,t,flg)                
% Subroutine for Pbs. 2.2.7, 2.5.7; discrete calculation of min drag
% nose shape; t--> x; s=[r d]'; r=radius, d=cumulative drag to x in
% units of pi*q*a^2, (r,x) in a=max radius; u=th, slope=tan(th);
%                                                 10/96, 3/97, 6/6/98
r=s(1); d=s(2); dx=dt; th=u; si=sin(th); c=cos(th);
if flg==1, f1=s+dx*[-si/c; (2*si^3/c)*(2*r-dx*si/c)];
elseif flg==2, f1=2*r^2+d; f2=[4*r 1];					       
elseif flg==3, f1=[1 0; 4*dx*si^3/c 1]; f2=dx*[-1/c^2; ...
         4*r*(3*si^2+si^4/c^2)-4*dx*(2*si^3/c+si^5/c^3)];
end

