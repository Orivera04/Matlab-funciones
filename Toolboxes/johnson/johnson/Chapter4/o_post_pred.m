function quan=o_post_pred(data,k,sample)

n=size(data,1);
p=size(data,2);
y=data(:,1); x=data(:,2:p);
m=size(sample,1);
L=size(sample,2);
g=sample(:,1:(k-2)); b=sample(:,(k-1):L);

q=zeros(m,k-1);

quan=zeros(n,2);

for i=1:n
   lp=(x(i,:)*b')';
   q(:,1)=Phi(-lp);
   for j=2:(k-1)
      q(:,j)=Phi(g(:,j-1)-lp);
   end
   u=rand(m,1);
   ys=ones(m,1);
   for j=1:(k-1);
      ys=ys+(u>q(:,j));
   end
   resid=sort(y(i)-ys);
   quan(i,:)=resid([m/4 3*m/4])';
end

figure
plot([1 1],quan(1,:))
hold on
for i=2:198,plot([i i],quan(i,:)),end
xlabel('observation number')
ylabel('posterior predictive residual')
hold off


function y = Phi(x)
% Phi computes the standard normal distribution function value at x
%
y = .5*(1+erf(x/sqrt(2)));
