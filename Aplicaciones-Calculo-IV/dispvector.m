
for i = 1:10
str = ['v',int2str(i), ' = 1:i;'];
eval(str)
end
for i = 1:10
eval(['v',int2str(i)])
end