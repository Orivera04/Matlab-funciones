function area1=areapol(x,y)
global n;
n=numel(x);sum=0;
for i=1:n-1
    area=x(i)*y(i+1)-x(i+1)*y(i);
    sum=sum+area;
end
area1=abs(0.5*sum);