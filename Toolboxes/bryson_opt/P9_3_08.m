% Script p9_3_08.m; min integral-square control to reverse velocity
% in a bounded space using FMINCON;                   11/94, 9/11/02
%
tic; N=32; el=.1; un=ones(1,N-1); t=[0:N]/N; t1=[.5:N-.5]/N; 
p0=[.8017 .6252 .4707 .3380 .2272 .1383 .0713 .0262 .0029 -.0029 ...
   -.0025 -.0020 -.0015 -.0010 -.0005 0 .0005 .0010 .0015 .0020 ...
    .0025 .0029 -.0029 -.0262 -.0713 -.1383 -.2272 -.3380 -.4707 ...
   -.6252 -.8017]; lb=p0-.1*un; ub=p0+.1*un;    % Converged solution
optn=optimset('Display','Iter','MaxIter',0);
p=fmincon('svic_f',p0,[],[],[],[],lb,ub,'svic_c',optn,N,el);
[f,a,v,y]=svic_f(p,N,el); toc     
%
figure(1); clf; subplot(311), plot(t,y,t,y,'.'); grid; ylabel('y')
axis([0 1 0 .11]); subplot(312), plot(t,v,t,v,'.'); axis([0 1 -1 1])
grid; ylabel('v'); subplot(313), plot(t1,a,'.',t1,a); grid
axis([0 1 -7 1]); ylabel('a'); xlabel('t')
