function prun      
% Example: prun
% ~~~~~~~~~~~~~
% Dynamics of an inverted pendulum integrated 
% by use of ode45.
%
% User m functions required: pinvert, mom

global ncal
th0=pi/8; w=.5; tmax=30; ncal=0;

fprintf('\nFORCED OSCILLATION OF AN ');
fprintf('INVERTED PENDULUM\n');
fprintf('\nNote: Generating four sets of\n');
fprintf('numerical results takes a while.\n');

% loose spring with liberal tolerance
alp=0.1; bet=1.0; gam=1.0; tol=1.e-4;
a1=num2str(alp); b1=num2str(bet);
g1=num2str(gam); e1=num2str(tol);
options=odeset('RelTol',tol);
[t1,z1]= ...
  ode45(@pinvert,[0,tmax],[0;w*th0],...
        options,alp,bet,gam,th0,w);
n1=ncal; ncal=0;

% loose spring with stringent tolerance
alp=0.1; bet=1.0; gam=1.0; tol=1.e-10;
a2=num2str(alp); b2=num2str(bet);
g2=num2str(gam); e2=num2str(tol);
options=odeset('RelTol',tol); 
[t2,z2]= ...
  ode45(@pinvert,[0,tmax],[0;w*th0],...
        options,alp,bet,gam,th0,w);
n2=ncal; ncal=0;

% tight spring with liberal tolerance
alp=0.1; bet=4.0; gam=0.5; tol=1.e-4;
a3=num2str(alp); b3=num2str(bet);
g3=num2str(gam); e3=num2str(tol);
options=odeset('RelTol',tol); 
[t3,z3]= ...
  ode45(@pinvert,[0,tmax],[0;w*th0],...
        options,alp,bet,gam,th0,w);
n3=ncal; ncal=0;

% tight spring with stringent tolerance
alp=0.1; bet=4.0; gam=0.5; tol=1.e-10;
a4=num2str(alp); b4=num2str(bet);
g4=num2str(gam); e4=num2str(tol);
options=odeset('RelTol',tol);
[t4,z4]= ...
  ode45(@pinvert,[0,tmax],[0;w*th0],...
        options,alp,bet,gam,th0,w);
n4=ncal; ncal=0; save pinvert.mat;

% Plot results
close; semilogy( ...
  t1,abs(z1(:,1)/th0-sin(w*t1)),'-r',...
  t2,abs(z2(:,1)/th0-sin(w*t2)),'--g',...
  t3,abs(z3(:,1)/th0-sin(w*t3)),'-.b',...
  t4,abs(z4(:,1)/th0-sin(w*t4)),':m');
title('Error Growth in Numerical Solution')
xlabel('dimensionless time'); 
ylabel('error measure');
c1=['Case 1: alp=',a1,', bet=',b1,', gam=', ...
    g1,', tol=',e1];
c2=['Case 2: alp=',a2,', bet=',b2,', gam=', ...
    g2,', tol=',e2];
c3=['Case 3: alp=',a3,', bet=',b3,', gam=', ...
    g3,', tol=',e3];
c4=['Case 4: alp=',a4,', bet=',b4,', gam=', ...
    g4,', tol=',e4];
legend(c1,c2,c3,c4,4); shg
dum=input('\nPress [Enter] to continue\n','s');
%print -deps pinvert

% plot a phase diagram for case 1
clf; plot(z1(:,2)/w,z1(:,1));
axis('square'); axis([-1,1,-1,1]);
xlabel('\theta''(\tau)/\omega'); ylabel('\theta');
title(['\theta versus ( \theta''(\tau) / ' ...
       '\omega ) for Case One']); figure(gcf);
%print -deps crclplt  
disp(' '); disp('All Done');

%=============================================

function zdot=pinvert(t,z,alp,bet,gam,th0,w)
%
% zdot=pinvert(t,z,alp,bet,gam,th0,w)
% ~~~~~~~~~~~~~~~~~
% Equation of motion for the pendulum
% 
% t    - time value
% z    - vector [theta ; thetadot]
% alp,bet,gam,th0,w
%      - physical parameters in the 
%        differential equation
% zdot - time derivative of z
%
% User m functions called:  mom
%----------------------------------------------

global ncal
ncal=ncal+1; th=z(1); thd=z(2);
c=cos(th); s=sin(th); lam=sqrt(5-4*c);
zdot=[thd; mom(t,alp,bet,gam,th0,w)+...
           s-alp*thd-bet*s*(1-gam/lam)];

%=============================================

function me=mom(t,alp,bet,gam,th0,w)
%
% me=mom(t,alp,bet,gam,th0,w)
% ~~~~~~~~~
% t  - time
% alp,bet,gam,th0,w
%    - physical parameters in the
%      differential equation
% me - driving moment needed to produce 
%      exact solution
%
% User m functions called:  none.
%----------------------------------------------

th=th0*sin(w*t); 
thd=w*th0*cos(w*t); thdd=-th*w^2;
s=sin(th); c=cos(th); lam=sqrt(5-4*c);
me=thdd-s+alp*thd+bet*s*(1-gam/lam);
