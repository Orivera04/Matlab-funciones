function fx = mul_l_exp(x)
% Script for the multiplication of linear expressions without coefficient constants
% this script returns a polynomial.
% --------------------------------
% Muhammad Rafiullah Arain
% Mathematics & Basic Sciences Department
% NED University of Engineering & Technology - Karachi
% Pakistan.
% www.geocities.com/rafi76pk
% ---------
%
% Example
% Compute the (x-2)(x+4)(x-5)...  
% write in following format.  here x is a Row Matrix
% >> x=[-2,4,5]
% >> mul_l_exp(x)

n = length(x);
p(n,n+1)=0;
p(1:n,1)=1;
p(1,2)=x(1);

for a=2:n;
   for b = 2:a;
   	p(a,b)= x(a) * p(a-1,b-1) + p(a-1, b);
   end
   p(a,a+1)=p(a-1,a)* x(a);
end
%------------
pw=n-1;
f=strcat(mat2str(abs(p(n,1))),'X^', num2str(n));
for a = 2: n-1;
   b = mat2str(abs(p(n,a)));
   if(p(n,a)<1);
      f= strcat(f,' - ', b,'X^', num2str(pw));
   else
      f= strcat(f,' + ', b,'X^', num2str(pw));
   end
   pw = pw -1;
end
	b = mat2str(abs(p(n,n)));
	if(p(n,n)<1);
      f= strcat(f,' - ', b,'X');
   else
      f= strcat(f,' + ', b,'X');
   end
   
	b = mat2str(abs(p(n,n+1)));
	if(p(n,n+1)<1);
      f= strcat(f,' - ', b);
   else
      f= strcat(f,' + ', b);
   end

fx=f;