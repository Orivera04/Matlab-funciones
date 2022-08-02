function [f,s,u]=tto(d,u,s0,sfd)
% Subroutine for p10_3_3a.m; motion of tractor-trailer;  1/97, 5/19/01
%
N=length(d); s=zeros(4,N+1); s(:,1)=s0; for i=1:N, ps=s(1,i);
  al=s(2,i); y=s(3,i); x=s(4,i); psn=ps+u(i)*d(i); z=tan(al/2);
  if abs(u(i))>0,
    yn=y-(cos(psn)-cos(ps))/u(i); xn=x+(sin(psn)-sin(ps))/u(i);
   else yn=y+d(i)*sin(ps); xn=x+d(i)*cos(ps); end
  if u(i)==0,
    zn=z*exp(-d(i)); aln=2*atan(zn);
   elseif abs(u(i))<1, als=asin(u(i)); zs=tan(als/2);
    c=((z-zs)/(z-1/zs))*exp(-d(i)*cos(als));
    zn=(zs-c/zs)/(1-c); aln=2*atan(zn);
   elseif abs(u(i))>1, us=sqrt(u(i)^2-1);
    p=atan((u(i)*z-1)/us); q=us*d(i)/2;
    zn=(1+us*tan(q+p))/u(i); aln=2*atan(zn);
   elseif abs(u(i))==1,
    aln=(2*atan(d(i)+tan(pi/4+u(i)*al/2))-pi/2)/u(i); end
s(:,i+1)=[psn aln yn xn]';
end; sf=s(:,N+1); f=sf-sfd;

