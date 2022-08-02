function c=fgenfit(func,x,y)
% Fits any functions to data using least squares.
%
% Example call: c=fgenfit(func,x,y)
% func is the user defined function to be fitted, for example see page 259. 
% x and y are vectors of the data. c are the coefficients of the fitted function.
%  
if any(size(x)~=size(y))
  disp('X and Y vectors must be the same size')
end
n=length(y);
[p,junk]=feval(func,x(1));
A=zeros(p,p); b=zeros(p,1);
for i=1:n
  [junk,f]=feval(func,x(i));
  for j=1:p
    for k=1:p;
      A(j,k)=A(j,k)+f(j)*f(k);
    end
    b(j)=b(j)+y(i)*f(j);
  end
end
c=A\b;
