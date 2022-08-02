% Script e08_3_1.m; 2nd order sufficient conditions - DTDP for max 
% uf w. vf=0 & yf spec. using DAMPC; s=[u v y x]'; psi=[v y]';
%                                                      8/97, 6/4/02
%
global psi; psi=[0 .2]'; name='dtdpc';
%
% Generate candidate path with DOPC:
N=50; th=(pi/3)*[1:-2/N:-1+2/N]; s0=[0 0 0 0]'; tf=1; k=-7;tol=5e-5;
[u,s,nu]=dopc(name,th,s0,tf,k,tol);
%
% Test sufficient conditions:
[s,K,Kf,Hu,phi,psi]=dampc(name,u,nu,s0,tf,psi); Huh=[Hu Hu(N)]; 
t=[0:1/N:1]; tk=t([1:N-1])'; Kh=[K; K(N-2,:)]; Kfh=[Kf; Kf(N-2,:)];
%
flg=2; if flg==1
% Path with revised initial and/or final BCs:
sn=s; un=u; clear s u; s(:,1)=s0; nt=2; dt=tf/N; 
for i=1:N, 
    u(i)=un(i)-K(i,:)*(s(:,i)-sn(:,i))+Kf(i,:)*[0 .22]'; 
    s(:,i+1)=feval(name,u(i),s(:,i),dt,(i-1)*dt,1); 
end 
end
%
figure(1); clf; plot(s(4,:),s(3,:)); grid; ylabel('y')
xlabel('x'); axis tight
%
figure(2); clf; subplot(311), plot(t,s(3,:)); grid; ylabel('y') 
axis tight; subplot(312), plot(t,s(2,:)); grid; ylabel('v')
subplot(313), zohplot(t,Huh); grid; ylabel('H_u'); axis tight
xlabel('t/t_f')
%
figure(3); clf; subplot(211), zohplot(t',Kh(:,2:3)); grid
ylabel('Gains'); legend('K_v','K_y',2); axis tight
subplot(212), zohplot(t',Kfh); grid; ylabel('Gains')
axis tight; xlabel('t/t_f'); legend('K_{fv}','K_{fy}',2) 
