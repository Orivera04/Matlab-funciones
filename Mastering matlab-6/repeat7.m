% repeat7.m
% repeated value creation and counting
% inverse operation

y=[3 3 0 0 0 5 6 6]; % data to examine

tmp=([1 diff(y)]~=0);
x=y(tmp);
n=diff(find([tmp 1]));