% repeat1.m
% repeated value creation and counting

x = [1 2 3 4];  % data to repeat
n = [1 2 3 4];  % repeat counts

y = [];
for i=1:length(x)
   y = [y repmat(x(i),1,n(i))];
end
y