function c = ex5manpcost(p,l,a,s,b,d,t);
%c = ex5manpcost(p,l,a,s,b,d,t)
%p(i) = p(promotion from grade i to i+1).
%l(i) = p(leaving from grade i).
%a(i) = p(new employee enters grade i).
%s(i) = salary of an employee in grade i.
%b(i) = bonus for promotion from grade i to i+1.
%d(i) = cost when an employe leaves the company from grade i.
%t(i) = cost of training when a new employee joins 
% grade i.
% outpout c(i) = expected cost per period in state i.



[mp np]= size(p);
[ma na] = size(a);
[ml nl] = size(l);
[mb nb]= size(b);
[ms ns]= size(s);
[md nd]= size(d);
[mt nt]= size(t);

if mp > 1 | ma > 1 | ml > 1 | ms >1 | mb > 1 | md > 1| mt >1
   msgbox('a, l, p, s, b, d, and t must be row vectors'); c='error'; return;
elseif max([na,nb,np,ns,nd,nt,nl]) - min([na,nb,np,ns,nd,nt,nl]) ~= 0
   msgbox('a, l, p, s, b, d, and t must have the same length'); c='error'; return;
elseif  any(p < 0) | any(p > 1) 
   msgbox('invalid value for p');c='error';return;
elseif  any(l < 0) | any(l > 1)
   msgbox('invalid value for l');c='error';return;
elseif  any(a < 0) | abs(sum(a)-1.0) > 10^(-12)
   msgbox('invalid value for a');c='error';return;
else
   c=zeros(na,1);
   for i=1:na
      c(i)=s(i) +b(i)*p(i) + (d(i)+ t*a')*l(i);
   end;
   
      
end;
