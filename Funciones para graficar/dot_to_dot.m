function dot_to_dot(X)
% DOT_TO_DOT  Conecta los puntos de una matriz 2-por-n .
%Dibuja segmentos, triángulos, cuadriláteros, etc.
%Ejemplo: >> dot_to_dot([1, 3, 5, 7;1, 9, 8, 2])
X(:,end+1) = X(:,1);
plot(X(1,:),X(2,:),'.-')
axis(10*[-1 1 -1 1])
axis square
