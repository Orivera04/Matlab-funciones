% Sympoly demos

%%

% Various ways to create a sympoly

% A scalar (zero) sympoly
z = sympoly;

% Scalar sympolys 'x', 'y', 'u', 'v' created in the current workspace
sympoly x y u v

% A sympoly (identity matrix) array
ayuh = sympoly(eye(3));

% Use deal to replicate a sympoly into several 
[a,b] = deal(sympoly);

% Deal can also create a sympoly array
S(1:2) = deal(sympoly('x'));

% As can repmat
R = repmat(sympoly('x'),2,3);

whos

%% 

% We can do arithmetic between sympolys, add, subtract, multiply,
% divide.

% add 1 to x
1 + x

%%

% double times a sympoly
2*y

%%

% subtraction, and a simple power
(x - y)^2

%%

% More complex expressions
(x - 2*y)^3/x + sqrt(y^3)

%%

%Synthetic division
[quotient,remainder] = syndivide(x^2+2*x-1,x+1)

%%

% Arrays of sympolys
[x , y ; 1 , x+y]

%%

% Arrays of sympolys
v = [1 x y x+y]

%%

% matrix multiplication
A = v'*v

%%

% Operations on arrays
sympoly lambda
(rand(3) - lambda*eye(3))

%%

% Even eigenvalues, using det, then roots 
roots(det(hilb(4) - lambda*eye(4)))

%%

% Sum on any dimension
sum(v,2)

%%

% And prod
prod(A(:))

%%

% 3rd and 4th order Legendre polynomials
p3 = orthpoly(3,'legendre')
p4 = orthpoly(4,'legendre')

%% 

% Orthogonal polynomials are orthogonal over the proper domain
defint(p3*p4,'x',[-1,1])

%%

% 2nd and 5th order Jacobi polynomials
p2 = orthpoly(2,'jacobi',2,3)
p5 = orthpoly(5,'jacobi',2,3)

%% 

% Orthogonal polynomials are orthogonal over the proper domain.
% Numerical issures left this just eps shy from zero.
defint(p2*p5*(1-x)^2*(1+x)^5,'x',[-1,1])

%%

% Roots of the derivative of a sympoly
sort(roots(diff(orthpoly(6,'cheby2'))))





