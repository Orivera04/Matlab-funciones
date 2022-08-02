% testdiffsum
% script file to test diffsum functions

times=zeros(1,2);
xcell={500 100 100 2};
xdata=rand(xcell{:});      % 500 x 100 x 100 x 2 array

N=1:1000;

tic
for i=N
   p=randperm(4);
   x=permute(x,p);
   y=mmdiffsum1(x,1);
end
times(1)=toc

tic
for i=N
   p=randperm(4);
   x=permute(x,p);
   y=mmdiffsum2(x,1);
end
times(2)=toc

relspeed=times/min(times)