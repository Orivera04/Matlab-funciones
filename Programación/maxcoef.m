function binewton = maxcoef(n)
%Determina el coeficiente m?ximo del binomio de Newton: (a+b)^n
m=fix(n/2);
binewton=nchoosek(n,m);
c=binewton;
disp(['El m?ximo coeficiente del desarrollo de (a+b)^',int2str(n),' es: '...
    ,int2str(c)])
end
