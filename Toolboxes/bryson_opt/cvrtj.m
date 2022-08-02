function [Ph,Ga,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts)
%CVRTJ - Converts cont. plant & QPI to disc. plant & equiv. QPI
%[Ph,Ga,Qd,Nd,Rd]=cvrtj(A,B,Q,N,R,Ts)
% Jcont=integral(x'Qx+2*x'Nu+u'Ru)dt, xdot=Ax+Bu; Jdisc=sum(x'Qd*x+
% 2x'Nd*ud+ud'Rd*ud), x(i+1)=Ph*x(i)+Ga*ud(i); Ts=sample time;
%                                                       5/30/89,  9/27/99
%
[ns,nc]=size(B); z1=zeros(ns); z2=zeros(ns,nc); R2=sqrt(R);
S=[-A' eye(ns) z1 z2; z1 -A' Q N/R2; z1 z1 A B/R2; zeros(nc,3*ns+nc)];
Sd=expm(S*Ts); D1=Sd([1:ns],[3*ns+1:3*ns+nc]); 
B2=Sd([ns+1:2*ns],[2*ns+1:3*ns]); C2=Sd([ns+1:2*ns],[3*ns+1:3*ns+nc]);
Ph=Sd([2*ns+1:3*ns],[2*ns+1:3*ns]); B3=Sd([2*ns+1:3*ns],[3*ns+1:3*ns+nc]);
Ga=B3*R2; Qd1=Ph'*B2;  Qd=(Qd1+Qd1')/2; Nd=Ph'*C2*R2; Rd1=B'*Ph'*D1; 
Rd=Ts*R+R2'*(Rd1+Rd1')*R2;

