function trian = pascal(n)
disp(['Triángulo de pascal: coeficientes de (a+b)^n. n= 1..',int2str(n)]);
trian= zeros(n,n+1);
for k=1:n
    b=zeros(1,k+1);
for i=1:k+1
  b(i)= nchoosek(k,i-1);
end
b= cat(2,b,zeros(1,n-k));
trian(k,:)=b;
end
trian;
end
