a = reshape(1:6,2,3)
b = num2cell(a)
b = num2cell(a, 1)
b{1}, b{2}, b{3}
b = num2cell(a, 2)
b{1}, b{2}
b = num2cell(a, [1,2])
