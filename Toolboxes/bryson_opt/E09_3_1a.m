% Script e09_3_1a.m; max range for double integ. plant w.
% bound on acceleration using FMINCON and ODE23      9/17//02
%
tic; N=50; s0=[0 0]'; load e09_3_1a; ta=[0:1/(N-1):1]; 
optn=optimset('Display','Iter','MaxIter',3); 
p=fmincon('dblint_f',p0,[],[],[],[],[],[],'dblint_c',optn,s0);
[f,t,s]=dblint_f(p,s0); y=s(:,1); v=s(:,2); a=p; 
%
figure(1); clf; subplot(311), plot(t,y,t,y,'.'); grid
axis([0 1 0 .25]); ylabel('y'); subplot(312)
plot(t,v,t,v,'.'); grid; axis([0 1 0 .5]); ylabel('v')
subplot(313), plot(ta,a,ta,a,'b.'); grid; ylabel('a')
axis([0 1 -1.1 1.1]); xlabel('Time')