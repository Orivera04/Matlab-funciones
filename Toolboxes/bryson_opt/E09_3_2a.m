% Script e09_3_2a.m; max range glide with h >=0 and al<almax 
% using FMINCON & ODE23, guessing the control history;  9/19/02
%
tic; alm=1/12; eta=.5; gas=atan(2*eta*alm); h0=1; z=180/pi; 
V0=1.1*sqrt(cos(gas)/alm); al0=[5:.5:15]/z;  un=ones(1,21);
tf=69/V0; p0=[al0 tf]; lb=[3*un/z 21]; ub=[16*un/z 25];
s0=[V0 0 h0 0]'; optn=optimset('Display','Iter','MaxIter',100);
p=fmincon('gld_f',p0,[],[],[],[],lb,ub,'gld_c',optn,s0); 
[f,t,s]=gld_f(p,s0); V=s(:,1); ga=s(:,2); h=s(:,3); x=s(:,4); 
N=length(p)-1; al=p(1:N); tf=p(N+1); ta=tf*[0:1/(N-1):1];
%
figure(1); clf; subplot(411), plot(x,V,x,V,'.'); grid
axis([0 72 1.8 4]); ylabel('V/sqrt(gl)'); subplot(412)
plot(x,z*ga,x,z*ga,'.'); grid; axis([0 75 -3 1])
ylabel('\gamma (deg)'); subplot(413), plot(x,h,x,h,'.'); 
ylabel('h/l'); grid; axis([0 72 -.1 1.1]); xlabel('x')
subplot(414), plot(ta,z*al,ta,z*al,'.'); axis([0 tf 3 15])
grid; xlabel('t'); ylabel('\alpha (deg)')
%
figure(2); clf; plot(V,h,V,h,'.'); xlabel('V/sqrt(gl)')
ylabel('h/l'); grid; axis([1.8 3.9 -.1 1.1]); toc

% Converges glacially slowly!!
