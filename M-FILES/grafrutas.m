function [x,y,z]=grafrutas(e1,e2)
k=1;
N=numel(e1);
for i=1:N
for j=1:N 
   if e2(i)==e1(j) &  e1(i)~= e2(j)
    e123(k)=e1(i);
    e123(k+1)=e2(i);
    e123(k+2)=e2(j);
    f(k)=e123(k);
    g(k+1)=e123(k+1);
    h(k+2)=e123(k+2);
    k=k+3;  
   end
end
end
x=f(f~=0)
y=g(g~=0)
z=h(h~=0)