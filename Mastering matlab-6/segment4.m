% segment4.m
% indexing array segments

%i = [1 5 13 22]; % test data
%j = [2 9 15 30];
n=length(i);

run=j-i+1;            % length of each run
ij=cumsum(run);       % last index of each run
ii=ij-run+1;          % first index of each run

idx=ones(1,ij(end));  % preallocate result

idx(1)=i(1);          % poke in first value
idx(1+ij(1:end-1))=i(2:n)-j(1:n-1); % poke in jumps
idx=cumsum(idx);
