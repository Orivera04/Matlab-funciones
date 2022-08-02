function M=borraFCER(A)
B=A;
v=0;
[m,n]=size(A);
for i=1:m  
  w=A(i,:);
  if elrep(w)==1
     v(i)=i;
  end
end
N=v(v~=0);
B(N,:)=[];
M=B;
