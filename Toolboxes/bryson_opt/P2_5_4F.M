% Script p2_5_4f.m; DVDP for max xf with V=1+y using DOP0F; 
% Fermat Pb.;                                 3/97, 3/28/02 
%
la0=[1 3.6265]'; u0=1.2950; N=40; N1=N+1; s0=[0 0]'; tf=2; 
name='dferm1'; optn=optimset('Display','Iter','MaxIter',10); 
la0=fsolve('dop0f',la0,optn,name,u0,s0,tf,N);
[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N); x=s(1,:); y=s(2,:);
t=tf*[0:1/N:1];
% 
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'ro'); grid
xlabel('x'); ylabel('y'); axis([0 4 0 3])
