function Itrap = trapecio1(f,h)
%Regla trapecial extendida version #1.f:integrando,h:paso.
%f debe ser un vector.
Itrap = h*(sum(f) - (f(1) + f(length(f)))/2);
