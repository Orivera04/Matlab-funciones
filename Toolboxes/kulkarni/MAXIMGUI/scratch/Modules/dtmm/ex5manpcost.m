function c = ex5manpcost(p,l,a,s,b,d,t);

% Returns vector of expected cost per period in state i
% Usage:  p(i) = p(promotion from grade i to i+1).
%         l(i) = p(leaving from grade i).
%         a(i) = p(new employee enters grade i).
%         s(i) = salary of an employee in grade i.
%         b(i) = bonus for promotion from grade i to i+1.
%         d(i) = cost when an employe leaves the company from grade i.
%         t(i) = cost of training when a new employee joins grade i.

na = size(a, 2) ;
c = zeros(na, 1);
for i = 1:na
  c(i) = s(i) + b(i)*p(i) + (d(i)+ t*a')*l(i);
end;
