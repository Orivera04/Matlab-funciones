function [c,hiba]=osszeg(f,n,m)
% a sorozat fuggvenyben definialt sorozat elemeinek
% osszege n es m kozotti indexekre. sum(a(i), i=n..m)
% ahol az a(i) elemeket a sorozat nevu fuggveny allitja elo
%
% © Molnarka Gy''oz''o 1998; program a Matlab programozasa c. reszhez

if n>m hiba='nem_jo_parameterek';  return; else 
for i=n:m b(i)=feval(f,i);end
c=sum(b);
end