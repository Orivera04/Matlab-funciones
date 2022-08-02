function x_prime = cl2ordf(t,x,flag,A)
% CALL: x_prime = cl2ordf(t,x,flag,A)     ;  Function to define the system   
%    x_prime = A*x at each point x(t);   A is the system matrix
%    Flag is a dummy variable in this case
x_prime=A*x;
%
% Test case with CL2ORD.M for Example 5.10
% x_prime(1)=   x(1) + x(2);
% x_prime(2)= 4*x(1) + x(2) ;

		