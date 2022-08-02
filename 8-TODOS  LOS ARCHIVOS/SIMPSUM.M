function	s=simpsum(y,DEL)
%Integral(s) integral(a,b,y) of equidistantly sampled function(s) y
%by Simpson method over interval(s) a<=x<=b of the same (DEL=scalar) 
%or different(DEL= vector) width(s) 
%For matrices y, the program works on columns of y
%Call:
%		s=simpsum(y[,DEL]), or, alternatively
%       s= simpsum(y).*DEL(:).';
%Input:
%		y = vector (or matrix) of function(s) values:
%		for several functions,their values are in columns
%		DEL =(vector or scalar or none) = range(s) of independent variable(s)
%		By default, DEL =1 (then s = accurate average value of y)
%       for matrices y, and different ranges of independent variables,
%       DEL should be a vector, length(DEL)=size(y,2)
%Output:
%		s = simpson integral(s)
%Vassili Pastushenko	19-th Aug.	1999
%========================================================

[a,b]=size(y);
if a==1
   y=y(:);
end
[N,b]=size(y);
if nargin<2,DEL=1;
else
    if length(DEL)==size(y,2)
        DEL=DEL(:).';
    end
end
h=DEL/(N-1);
if rem(N,2)==0
s=sum(y)-5/8*(y(1,:)+y(N,:))+(y(2,:)+y(N-1,:))/6-(y(3,:)+y(N-2,:))/24;
s=s.*h;
else
s=(2*sumv(y(3:2:N-2,:))+4*sumv(y(2:2:N-1,:))+y(1,:)+y(N,:)).*h/3;
end

%==============================
function s=sumv(V)
a=size(V,1);
if a==1
   s=V;
else
   s=sum(V);
end