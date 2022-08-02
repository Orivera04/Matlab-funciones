N=10;
A=(randperm(N)+randperm(N))*2;
A=unique(A);
B=randperm(N)+randperm(N)+randperm(N);

M=1;
tol=eps;
tol2=2*tol;
tic
Bb=B(B>min(A) & B<max(A));
for k=1:M
c1 = logical(zeros(size(A)));
for i=1:prod(size(A))
     c1(i)=sum(abs(A(i)-Bb)<=tol2);
end
end
times(1)=toc;
tic
for k=1:M
   a=A(:);
   a=sort([a*(1-tol);a*(1+tol)]);
   c2=histc(Bb,a);
   c2=c2(1:2:end);
end
times(2)=toc
c1,c2
%reltimes=times/min(times)