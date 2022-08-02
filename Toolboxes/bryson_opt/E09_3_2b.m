% Script e09_3_2b.m; max range glide with h >=0 and al<almax 
% using FMINCON & ODEU, guessing the control history;  9/18/02
%
tic; alm=1/12; eta=.5; 
gas=atan(2*eta*alm); V0=1.1*sqrt(cos(gas)/alm);
h0=1; z=180/pi; al0=[5:.5:15]/z; tf=23; p0=[al0 tf]; 
s0=[V0 0 h0 0]'; optn=optimset('Display','Iter','MaxIter',60);
lb=[3*ones(1,21)/z 21]; ub=[16*ones(1,21)/z 25];
p=fmincon('gldb_f',p0,[],[],[],[],lb,ub,'gldb_c',optn,s0); 
[f,s]=gldb_f(p,s0); V=s(1,:); ga=s(2,:); h=s(3,:); x=s(4,:); 
N=length(p)-1; al=p(1:N); tf=p(N+1); t=tf*[0:1/(N-1):1];
%
figure(1); clf; subplot(411), plot(t,V,t,V,'.'); grid
axis([0 24 1.8 4]); ylabel('V/sqrt(gl)'); subplot(412)
plot(t,z*ga,t,z*ga,'.'); grid; axis([0 24 -3 1])
ylabel('\gamma (deg)'); subplot(413), plot(t,h,t,h,'.'); 
ylabel('h/l'); grid; axis([0 24 -.1 1.1])
subplot(414), plot(t,z*al,t,z*al,'.'); axis([0 24 3 15])
grid; xlabel('t'); ylabel('\alpha (deg)')
%
figure(2); clf; plot(V,h,V,h,'.'); xlabel('V/sqrt(gl)')
ylabel('h/l'); grid; axis([1.8 3.9 -.1 1.1]) 
toc
