% segment2.m
% indexing array segments

%i = [1 5 13 22]; % test data
%j = [2 9 15 30];

run=j-i+1;            % length of each run
ij=cumsum(run);       % last index of each run
ii=ij-run+1;          % first index of each run
idx=zeros(1,ij(end)); % preallocate result

for k=1:length(i)
   idx(ii(k):ij(k))=i(k):j(k);
end