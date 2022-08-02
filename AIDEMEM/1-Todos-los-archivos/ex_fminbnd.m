f=inline('tan(x)./(x.*x)');
option=optimset('tolX', 1.0E-8);
[sol, val]=fminbnd(f, eps, pi/2-eps, option); 
fprintf('fminimum à x = %7.4f de valeur %7.4f',sol,val);

