function p = goldie
%GOLDIE  What does this function do?

p = 0
A = [1 1; 1 0]
x = [1 1]'
while p ~= x(1)/x(2)
   p = x(1)/x(2)
   x = A*x
end
