function R=elimiguales1(M)
%Programa que borra vectores iguales en una Matriz.
[n,m]=size(M);

for i=1:n
    for j=i+1:n
        if M(i,1)==M(j,1) & M(i,2)==M(j,2) 
          M(j,:)=[0,0]; 
        end
    end
end
A=M(:,1);B=M(:,2);C=A(A~=0);D=B(B~=0);N=[C,D];
R=N;



