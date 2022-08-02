% testsegment
% script file to test segment implementations

i=10*(1:1000);
j=i+5;

N=1:100;
times=zeros(1,4);

tic
for t=N, segment1, end % no preallocation
times(1)=toc;

tic
for t=N, segment2, end % For Loop
times(2)=toc;

tic
for t=N, segment3, end % EVAL
times(3)=toc;

tic
for t=N, segment4, end %cumsum
times(4)=toc

relspeed=times/min(times)