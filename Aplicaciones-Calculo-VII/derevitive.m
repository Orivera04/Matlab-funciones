% This function calculates the n-th Derevetive of polynomial function 
a = input ( ' Enter the coefficints of the function ' ) ;
poly2sym(a)
n = input ( ' Now give n [ for calculating the n-th degree ] ' );
for i=1:n 
    a = polyder(a) ; 
end
poly2sym(a) 