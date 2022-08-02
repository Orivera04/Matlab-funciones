% Exercicios_propostos_10
echo on
E1 = sym('diff(x(t),t)*sin(x(t)) + diff(y(t),t)*cos(y(t))')
pretty(E1)
E2 = diff(E1)
% '$(t,2)' significa segunda derivada
pretty(E2)
