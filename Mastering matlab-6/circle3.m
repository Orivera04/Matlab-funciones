% circle3.m
% circular addressing

x=-3:3;        % data to work on
n=1;           % relative shift
r=5;           % total number of rows
lx=length(x);
y=zeros(r,lx);   % preallocate
y(1,:)=x;        % first row is x
idx=zeros(r,lx); % capture indices
idx(1,:)=1:lx;

for i=2:r
   tmp=y(i-1,:); % row to shift
   idx(i,:)=mod((1:lx)-(n+i-2)-1,lx)+1;
   y(i,:)=tmp(idx(i,:));
end
idx