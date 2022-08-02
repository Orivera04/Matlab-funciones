function [B,R]=mat_rutas(A,N)
B=A;
[h,k]=find(B==N);
R=B(h,:);
B(h,:)=[];