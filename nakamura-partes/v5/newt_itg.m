% Newt_itg(f_name, a, b, n) integrates a function named by f_name 
% by Newton closed integration formula of order n.
% f_name is the function that defines the function to integrate,
% a and b are lower and upper limits, and n is the order of
% Newton closed integration formula. 
% Copyright S. Nakamura, 1995
function I = Newt_itg(f_name, a, b, n)
npt=n+1;
if npt<0, break; end
en = npt:-1:1;
x = 1:npt;
for i=1:npt
      power_2(i)  = npt^en(i); power_1(i) = 1^en(i);
end
for j=1:npt
      z = zeros(1,npt) ;  z(j)=1;
      a1 = polyfit(x, z,npt-1);
      w(j) = sum(a1.*(power_2 - power_1)./en);
%      fprintf(' j=%3.0f       w=%12.8f\n', j, w)
end
x=a:(b-a)/(npt-1):b;
y=feval(f_name,x);
I = sum(w.*y)*(b-a)/(npt-1);
fprintf('\n     x            y            w \n')
for j=1:npt
fprintf('%e %e %e\n', x(j),y(j), w(j))
end

