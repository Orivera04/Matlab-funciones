% Práctica 2.3: Calcular las normas 1, infinito y Fröbenius de una matriz cuadrada.
A=input('Dame la matriz \n');
n=size(A,1);
for i=1:n
   n1(i)=sum(abs(A(:,i)));
   ninf(i)=sum(abs(A(i,:)));
   nf(i)=sum(abs(A(:,i)).^2);
end
norm1=max(n1);
norminf=max(ninf);
normf=sqrt(sum(nf));
disp(' ')
disp('  Norma   Valor calculado  Valor con MATLAB')
fprintf(' Norma 1      %3.3f            %3.3f \n',norm1,norm(A,1));
fprintf('Norma inf     %3.3f            %3.3f \n',norminf,norm(A,inf));
fprintf('Fröbenius     %3.3f            %3.3f \n',normf,norm(A,'fro'));
