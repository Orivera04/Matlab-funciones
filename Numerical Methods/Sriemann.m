function Sriemann(f,a,b)

% Calcula la suma de Riemann, para lo cual se introduce la función f, y los
% valores de los intervalos a evaluar, posteriormente se grafica la
% funcion f
% ejemplo: syms x; Srieman(x + 2*x^3, 1, 3)
xmed = (b - (b-1))/2;

j=1;
for i=a:xmed:b-xmed 
    u(j) = subs(f,'x',i+(xmed/2));
    j=j+1;
end

s1=sum(u)*xmed;
disp(double(s1));
rsums(f,a,b);
