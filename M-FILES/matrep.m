function B=matrep(MR,A,e,k)
%R�plica de una fila de una matriz de sub-ruta
R=[];  
x= A(k,:);
ultimo=x(end);
ne=e(ultimo);
P=repmat(x,ne,1);
for j=1:ne
    R=[R;P(j,:),MR(ultimo,j)];
end
B=R;
