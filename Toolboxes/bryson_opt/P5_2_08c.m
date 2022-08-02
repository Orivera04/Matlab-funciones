% Script p5_2_08c.m; triple integrator plant - analytic solution;
% s=[y v a]';                                          5/98, 3/31/02
%
tf=3.915; T=tf; N=100; sa=1e2; sv=sa; sy=sa; 
M=[-T^3/6-T^2/(2*sa) -T^4/24+T/sv -T^5/60-2/sy; ...
   T^2/2+T/sa T^3/6-1/sv T^4/12; -T-1/sa -T^2/2 -T^3/3];
n=[-1 0 0]'; Ai=M\n; t=tf*[0:1/N:1]; un=ones(1,N+1); T=tf*un-t; 
u=Ai'*[un; T; T.^2]; a=Ai'*[-T; -T.^2/2; -T.^3/3]; t=t/tf;
v=Ai'*[T.^2/2; T.^3/6; T.^4/12]; y=Ai'*[-T.^3/6; -T.^4/24; -T.^5/60]; 
%
figure(1); clf; subplot(211), plot(t,y,'b',t,v,'r--',t,a,'g-.'); 
grid; legend('y','v','a')   
subplot(212); plot(t,u,'b'); grid; ylabel('u'); xlabel('t/t_f')