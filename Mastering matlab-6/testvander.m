% testvander.m
% script file to test vandermonde implementations

x=randn(10000,1);      % column vector for input data
m=100;                 % highest power to compute
   
times=zeros(1,6);

tic
vander1
times(1)=toc;

tic
vander2
times(2)=toc;

tic
vander3
times(3)=toc;

tic
vander4
times(4)=toc;

tic
vander5
times(5)=toc;

tic
vander6
times(6)=toc;

relspeed=times/min(times) % relative speed results