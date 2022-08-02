% Cheby_pw(n) finds coefficients of the 
% Chebyshev polynomial of order n in power series form.
% Copyright S. Nakamura, 1995
function pn = Cheby_pw(n)
pbb=[1];  if n==0, pn=pbb; break; end
pb=[1 0]; if n==1, pn=pb;  break; end
for i=2:n;
   pn=   2*[pb,0] - [0, 0, pbb] ;
   pbb=pb; pb=pn;
end

