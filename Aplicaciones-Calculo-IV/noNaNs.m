clc;
x=[1 inf 2 3 inf 4 inf]
n=numel(x);
k=0;
for i=1:n
    if x(i)== inf
      continue   
    else
 k=k+1;
 y(k)=x(i);
    end
end
y
    