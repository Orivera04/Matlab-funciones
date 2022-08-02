function cbinom = coefic(n)
%Coeficientes de (a+b)^n
for i=1:n+1
    coef(i)=nchoosek(n,i-1);
end
cbinom=coef;