% circle4.m
% circular addressing

x=-3:3;        % data to work on
n=1;           % relative shift
r=5;           % total number of rows
lx=length(x);

[idxa,idxb]=meshgrid(1:lx,-n*(0:r-1));
idx=mod(idxa+idxb-1,lx)+1;
y=x(idx);      % final result by indexing