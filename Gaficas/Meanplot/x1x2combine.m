function x3 = x1x2combine(x1, x2)
% combine x1 x2 -> x (all non-repeated values)
% example: x1 = [1 2 3], x2 = [1.2 2 3 3.5] -> x3 = [1 1.2 2 3 3.5]

% if you want only the x values that x1 and x2 overlap, uncomment the
% following codes. example: x1 = [1 2 3], x2 = [1.2 2 3 3.5] -> x3 = [1.2
% 2 3]
%% --------------------------------->
% min1 = min(x1);
% min2 = min(x2);
% max1 = max(x1);
% max2 = max(x2);
% minx = max(min1, min2);
% maxx = min(max1, max2);
% 
% x1 = x1(x1 >= minx);
% x2 = x2(x2 >= minx);
% 
% x1 = x1(x1 <= maxx);
% x2 = x2(x2 <= maxx);
%% <-------------------------------

n = 0;
for k = 1:length(x2)
    if sum(x2(k) == x1) == 0
        n = n + 1;
        xtemp(n) = x2(k);
    end
end
if n == 0   %x1 = x2
    x3 = x1;
else
    x3 = [x1 xtemp];
    x3 = sort(x3);
end
