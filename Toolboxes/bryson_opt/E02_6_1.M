% Script e02_6_1.m; min drag nose shape using FOP0N;   2/97, 6/21/02
%
% Converged initial guess:
u0=[.18 .18 .19 .19 .19 .20 .20 .20 .21 .21 .22 .22 .23 .24 .25 .26 ...
    .27 .29 .33 .39 .88]; s0=[0 1]'; tf=4; 
% u0=.3*ones(1,21);        % Crude initial guess
name='noshp'; optn=optimset('Display','Iter','MaxIter',500); 
u=fsolve('fop0n',u0,optn,name,s0,tf);
[f,s]=fop0n(u,name,s0,tf); r=s(2,:); x=tf*[0:1/20:1];
%
figure(1); clf; plot(x,r,x,-r,'b'); grid; axis([0 4 -1.5 1.5]) 