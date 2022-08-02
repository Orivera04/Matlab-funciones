% Script e02_4_1.m; min drag nose shape using FOP0;      8/97, 7/11/02
%
u=[.18 .18 .19 .19 .19 .20 .20 .20 .21 .21 .22 .22 .23 .24 .25 .26 ...
   .28 .29 .34 .38 .68]'; tf=4; N=length(u)-1; tu=tf*[0:1/N:1]';
name='noshp'; s0=[0 1]'; k=.12; told=1e-5; tols=3e-4; mxit=15;
[t,u,s,la0,Hu]=fop0(name,tu,u,tf,s0,k,told,tols,mxit); r=s(:,2); 
%
figure(1); clf; plot(t,r,t,-r,'b'); grid; xlabel('x/r_o') 
ylabel('r/r_o'); axis([0 4 -1.5 1.5])
%
figure(2); clf; plot(t,u); grid; xlabel('x/r_o'); ylabel('u')