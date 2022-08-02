% Script e04_5_2.m; TDP for min time transfer to Mars orbit using 
% FMINCON and ODE23; s=[r u v]';                    3/97, 9/19/02 
%
be0=[0.4310  0.4663  0.5045  0.5457  0.5902  0.6380  0.6893 ...
  	 0.7441  0.8026  0.8648  0.9306  1.0002  1.0735  1.1507 ...
  	 1.2324  1.3196  1.4151  1.5252  1.6675  1.9044  2.5826 ...
     3.9427  4.4209  4.6081  4.7222  4.8071  4.8768  4.9373 ...
     4.9913  5.0407  5.0864  5.1292  5.1695  5.2077  5.2442 ...
     5.2792  5.3129  5.3456  5.3773  5.4083  5.4386];
tf=3.3155; p0=[be0 tf]; s0=[1 0 1]';        % Converged solution
optn=optimset('Display','Iter','MaxIter',5);
lb=[be0-.01 3.31]; ub=[be0+.01 3.32];        % Note tight bounds
p=fmincon('mart_f',p0,[],[],[],[],lb,ub,'mart_c',optn,s0);
[c,ceq,t,s]=mart_c(p,s0); N=length(be0); be=p([1:N]); tf=p(N+1);
tb=tf*[0:1/(N-1):1]; r=s(:,1); u=s(:,2); v=s(:,3); N1=length(t);
rf=r(N1); th=cumtrapz(t,v./r); z=180/pi; 
for i=1:91, th1(i)=(i-1)*pi/90; end; x=r.*cos(th); y=r.*sin(th); 
%
figure(1); clf; plot(x,y,x,y,'b.',1,0,'ro',x(N1),y(N1),'ro',...
   cos(th1),sin(th1),'r--',rf*cos(th1),rf*sin(th1),'r--'); grid
axis([-1.6 1.1 -.6 2.1]); axis('square'); ylabel('y')
xlabel('x')
%
figure(2); clf; plot(t,u,t,v,t,r); grid; legend('u','v','r',2)
axis([0 tf 0 1.6]); xlabel('Time');
%
figure(3); clf; plot(tb,be*z,tb,be*z,'b.'); grid
ylabel('\beta (deg)'); axis([0 tf 0 360]); xlabel('Time')

% Convergence is very slow if initial guess is only slightly
% off optimal.