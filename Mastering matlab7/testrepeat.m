% testrepeat
% script file to test repeat implementations

xdata=rand(1,200);               % data to test
ndata=repmat([3 8 2 1 0 6 9 5 7 4],1,200/10); % counts

N=1:200;

x=xdata;  % refresh data
n=ndata;
for i=N, repeat1, end

x=xdata;  % refresh data
n=ndata;
for i=N, repeat2, end

x=xdata;  % refresh data
n=ndata;
for i=N, repeat3, end