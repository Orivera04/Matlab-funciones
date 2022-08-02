function Q=aitken1(x,y,xval)
% Aitken's method for interpolation.
%
% Example call: Q=aitken(x,y,xval)
% x and y give the table of values. Parameter xval is
% the value of x at which interpolation is required. 
% Q is interpolated value, no output of intermediate results.
%
n=length(x); P=zeros(n);
P(1,:)=y;
for j=1:n-1
  for i=j+1:n
     P(j+1,i)=(P(j,i)*(xval-x(j))-P(j,j)*(xval-x(i)))/(x(i)-x(j));
  end		
end
Q=P(n,n);
