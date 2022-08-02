% Script f04_17.m; TDP for min time to Mars orbit using FOPTF;
%                                                  3/97, 9/5/02
%
la0=[-5.2749 -2.6133 -5.6845]; nu=[-3.7562 4.0009 -3.5513];
tf=3.3155; p=[la0 nu tf]; name='mart'; s0=[1 0 1]'; 
optn=optimset('Display','Iter','MaxIter',3); 
p=fsolve('foptf',p,optn,name,s0); [f,t,y]=foptf(p,name,s0); 
be=180*(atan2(y(:,5),y(:,6))+pi*ones(size(t)))/pi;
%
figure(1); clf; plot(t,y(:,[1:3])); grid; axis([0 3.5 0 1.6])
xlabel('Time'); legend('r','u','v',2)
%
figure(2); clf; plot(t,be); grid; axis([0 3.5 0 350])
ylabel('\beta (deg)'); xlabel('Time') 
%
figure(3); clf; plot(t,y(:,[4:6])); grid; axis([0 3.5 -6 5])
xlabel('Time'); legend('\lambda_r','\lambda_u','\lambda_v',2)
