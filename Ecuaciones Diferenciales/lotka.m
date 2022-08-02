function yp = lotka(t,y)
%Modelo de Lotka-Volterra depredador-presa
global alpha beta;
yp = [y(1) - alpha*y(1)*y(2); -y(2) + beta*y(1)*y(2)];
end