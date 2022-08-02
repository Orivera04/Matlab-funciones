function pascal=matcoef(n)

for k=1:n
    b=zeros(1,k+1);
for i=1:k+1
  b(i)= nchoosek(k,i-1);

end
b= cat(2,b,zeros(1,n-k))
end
end