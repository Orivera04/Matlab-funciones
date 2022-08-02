function [y,y1,u]=stepcmd(A,B,C,D,K,yc,C1,D1,t)
%STEPCMD - Generates time responses to step command y=yc.
% [y,y1,u]=stepcmd(A,B,C,D,K,yc,C1,D1,t)
   % Uses feedforward and feedback at points defined by 
   % vector t; xdot=Ax+Bu, u=-K*x; y=Cx+Du, dim(u)=dim(y);
   % y1=C1*x+D1*u.
   %
[ns,nc]=size(B);          B1=zeros(ns,1);
Xas=[A,B;C,D]\[B1;yc];    Xs=Xas([1:ns]);
Us=Xas([ns+1:ns+nc]);     X0=-Xs;
y1s=C1*Xs+D1*Us;
C=[C;C1];                 D=[D;D1];
[n1,ns]=size(C1);
C2=[C-D*K;-K];            D2=zeros(2*nc+n1,1);
T=length(t);    Z1=zeros(T,1); 	U1=ones(T,1);
Y=lsim(A-B*K,B1,C2,D2,Z1,t,X0); 
y=Y(:,[1:nc])+U1*yc';
y1=Y(:,[nc+1:nc+n1])+U1*y1s';
u=Y(:,[nc+n1+1:2*nc+n1])+U1*Us';

