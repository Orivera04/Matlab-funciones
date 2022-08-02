a = fix(rand(3,4)*26)+97
[mini, i] = min(a)

b = char(a)
[t,i] = sort(b)
[t,i] = sortrows(b)