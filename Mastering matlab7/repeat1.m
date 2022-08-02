% repeat1.m
% repeated value creation and counting

%x = [3 2 0 5 6];  % data to repeat
%n = [2 0 3 1 2];  % repeat counts

y = [];
for i=1:length(x)
   y = [y repmat(x(i),1,n(i))];
end