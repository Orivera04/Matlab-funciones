% f4_3 same as L4_1
%  See Example 4.4. Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 4.3; List4.1')
clear,clf,hold off
x = [1.1,   2.3,   3.9,   5.1]';
y = [3.887, 4.276, 4.651, 2.117]' ;
n=length(x)-1 ;
a(:,n+1)=ones(size(x));
a(:,n)=x;
for j=n-1:-1:1
   a(:,j)=a(:,j+1).*x;
end
coeff=a\y;    %Solution of linear equation.
xi=[2.101, 4.234];
yi=zeros(size(xi));
for k=1:n+1       
   yi = yi + coeff(k)*xi.^(n+1-k);
end
%   plotting
xp=1.1:0.05:5.1;
yp=zeros(size(xp));
for k=1:n+1
   yp = yp + coeff(k)*xp.^(n+1-k);
end
plot(xp,yp, x,y,'o')
xlabel('x')
ylabel('g(x):-,  data points: o')

