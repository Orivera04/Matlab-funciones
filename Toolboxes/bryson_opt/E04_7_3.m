% Script e04_7_3.m; TDP for min time to Mars orbit using FOPTB;
% s=[r u v]';	                                    3/97, 9/5/02
%
clear global; global rf; rf=1.5237; sf=[1.5213 .0052 .7994];
nu=[-4.7924 5.0493 -4.2129]; tf=3.2493; p=[sf nu tf]; name='mart';
s0=[1 0 1]'; optn=optimset('Display','Iter','MaxIter',500);
p=fsolve('foptb',p,optn,name,s0); [f,t,y]=foptb(p,name,s0);
be=(180/pi)*(atan2(y(:,5),y(:,6))+pi*ones(size(t))); N=length(t);
tf=p(7); 
%
figure(1); clf; plot(t,y(:,[1:3])); grid; axis([0 3.5 0 1.6])
xlabel('Time'); legend('r','u','v',2)
%
figure(2); clf; plot(t,be); grid; axis([0 3.5 0 350])
ylabel('\beta (deg)'); xlabel('Time') 
%
figure(3); clf; plot(t,y(:,[4:6])); grid; xlabel('Time')
legend('\lambda_r','\lambda_u','\lambda_v',2)
