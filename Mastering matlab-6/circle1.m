% circle1.m
% circular addressing

x=-3:3;        % data to work on
n=1;           % relative shift
r=5;           % total number of rows
lx=length(x);
y=zeros(r,lx);   % preallocate
y(1,:)=x;        % first row is x

for i=2:r
   tmp=y(i-1,:); % row to shift
   y(i,:)=tmp(mod((1:lx)-n-1,lx)+1);
end