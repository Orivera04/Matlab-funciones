a = fix(rand(3, 5)*100)
for i = -2:4
  v =  diag(a, i)'
end;
b =  diag(diag(a))

c = [ {'a'}, {'b'}; {'c'}, {32}]
e = diag(c)'
f = diag(e)