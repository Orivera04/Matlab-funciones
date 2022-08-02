% segment3.m
% indexing array segments

%i = [1 5 13 22]; % test data
%j = [2 9 15 30];

idx=eval(cat(2,'[',sprintf('%d:%d,',[i;j]),']'));