% Script p2_5_4n.m; DVDP for max xf with V=1+y using DOP0N; Fermat Pb; 
%                                                        4/97, 3/28/02 
%
u0=[1.295 1.281 1.266 1.251 1.235 1.218 1.200 1.182 1.162 1.142 ...
    1.121 1.098 1.075 1.051 1.026 0.999 0.971 0.943 0.913 0.882 ...
    0.849 0.815 0.781 0.744 0.707 0.669 0.629 0.588 0.546 0.502 ...
    0.458 0.413 0.366 0.319 0.272 0.223 0.174 0.125 0.075 0.025];
N=length(u0); s0=[0 0]'; tf=2; name='dferm1'; 
optn=optimset('Display','Iter','MaxIter',50);
u=fsolve('dop0n',u0,optn,name,s0,tf);
[f,s,la0]=dop0n(u,name,s0,tf); uh=[u u(N)]; x=s(1,:); y=s(2,:);
t=tf*[0:N]/N; N1=N+1;
% 
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'ro'); grid
xlabel('x'); ylabel('y'); text(3.3,2.55,'t_f=2')
%
figure(2); clf; zohplot(t,uh); grid; xlabel('Time'); ylabel('u')
