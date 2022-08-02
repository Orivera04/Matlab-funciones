function func2
% func2 increments a persistent variable "count"
% Format func2 or func2()

persistent count
 
if isempty(count)
    count = 0;
end
count = count + 1;
fprintf('The value of count is %d\n',count)
end
