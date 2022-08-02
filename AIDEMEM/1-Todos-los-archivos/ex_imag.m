% scipt ex_minrac
function ex_minrac  
m = linspace(-5, 5, 500);
for i = 1:500   y(i) = minrac(m(i)); end;
plot(m, y); 

function x = minrac(m)
  m = m(:);
  p = [1 0 m 0 -m 1];
  r = roots(p);
  r = r(real(r) == r);
  x =  min(r); 