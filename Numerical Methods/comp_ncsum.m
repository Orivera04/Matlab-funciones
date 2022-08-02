function quad = comp_ncsum ( f, a, b, n, m)
%
%  function quad = comp_ncsum ( f, a, b, n, m )
%
%  Return the value of the compositie N-th order Newton-Cotes approximation 
%  that uses M subintervals to approximate the integral from A to B of F(X).  
%
ends = linspace ( a, b, m+1);
quad = 0.0;
for i = 1:m
  quad = quad + ncsum ( f, ends(i), ends(i+1), n );
end




