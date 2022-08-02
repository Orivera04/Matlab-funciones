% testrepeati
% script file to test repeat implementations

N=100;
xdata=rand(1,N);               % data to test
ndata=repmat(randperm(20),1,N/20); % counts

x=xdata;  % refresh data
n=ndata;
repeat3

N=1:200;
t=zeros(1,3);
tic
for i=N, repeat4, end
t(1)=toc;
tic
for i=N, repeat5, end
t(2)=toc;
tic
for i=N, repeat6, end
t(3)=toc
