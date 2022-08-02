a = roots([1 2 3 4 5 6]).'
b =  cplxpair(a)
c =  [a 1+i]; 
try
d =  cplxpair(c)
catch
  lasterr
end