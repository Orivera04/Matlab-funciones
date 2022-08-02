function out=gradplot(X,Y,Z,len)
[U,V]=gradient(Z,len);
quiver(X,Y,U,V)
