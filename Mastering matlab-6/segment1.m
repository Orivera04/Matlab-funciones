% segment1.m
% indexing array segments

%i = [1 5 13 22]; % test data
%j = [2 9 15 30];

idx=[];
for k=1:length(i)
   idx=cat(2,idx,i(k):j(k));
end