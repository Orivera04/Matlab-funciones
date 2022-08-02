% Script p2_5_4b.m; DVDP for max xf with V=1+y using DOP0B; Fermat Pb.;
%                                                         3/97, 3/28/02 
%
sf=[3.6265 2.7622]'; uf=0.0250; N=40; N1=N+1; s0=[0 0]'; tf=2;
name='dferm1'; optn=optimset('Display','Iter','MaxIter',500); 
sf=fsolve('dop0b',sf,optn,name,uf,s0,tf,N);
[f,s,u]=dop0b(sf,name,uf,s0,tf,N); x=s(1,:); y=s(2,:); t=tf*[0:1/N:1];
% 
figure(1); clf; plot(x,y,x,y,'.',x(N1),y(N1),'ro'); grid
xlabel('x'); ylabel('y'); axis([0 4 0 3]); text(3.3,2.55,'t_f=2')
