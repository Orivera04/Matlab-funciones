% testrepeat
% script file to test repeat implementations

xdata=rand(1,10000);               % data to test
ndata=repmat([3 8 2 1 0 6 9 5 7 4],1,10000/10); % counts

N=1:10;
times=zeros(1,4);

x=xdata;  % refresh data
n=ndata;
tic
for i=N, repeat1, end
times(1)=toc

x=xdata;  % refresh data
n=ndata;
tic
for i=N, repeat2, end
times(2)=toc;

x=xdata;  % refresh data
n=ndata;
tic
for i=N, repeat3, end
times(3)=toc;

x=xdata;  % refresh data
n=ndata;
tic
for i=N, repeat4, end
times(4)=toc

relspeed=times/min(times)