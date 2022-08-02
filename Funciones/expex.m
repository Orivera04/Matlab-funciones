function s = expex(t)
%EXPEX  Experimental version of EXP(T)

s = 1;
term = 1;
n = 0;
r = 0;
while r ~= s
   r = s;
   n = n + 1;
   term = (t/n)*term;
   s = s + term;
   fprintf('%5d %14.4g %25.15g \n',n,term,s)
end
