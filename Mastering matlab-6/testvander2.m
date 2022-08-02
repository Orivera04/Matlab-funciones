% testvander2.m
% script file to test vandermonde implementations

x=randn(100,1);      % column vector for input data
m=10;                % highest power to compute
N=1:500;
   
times=zeros(1,6);

tic
for i=N, vander1, end
times(1)=toc;

tic
for i=N, vander2, end
times(2)=toc;

tic
for i=N, vander3, end
times(3)=toc;

tic
for i=N, vander4, end
times(4)=toc;

tic
for i=N, vander5, end
times(5)=toc;

tic
for i=N, vander6, end
times(6)=toc;

relspeed=times/min(times) % relative speed results