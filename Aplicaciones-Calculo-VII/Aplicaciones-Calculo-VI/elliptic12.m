function [F,E,Z] = elliptic12(u,m,tol)
% ELLIPTIC12 evaluates the value of the Incomplete Elliptic Integrals 
% of the First, Second Kind and Jacobi's Zeta Function.
%
%   [F,E,Z] = ELLIPTIC12(U,M,TOL) where U is a phase in radians, 0<M<1 is 
%   the module and TOL is the tolerance (optional). Default value for 
%   the tolerance is eps = 2.220e-16.
%
%   ELLIPTIC12 uses the method of the Arithmetic-Geometric Mean 
%   and Descending Landen Transformation described in [1] Ch. 17.6,
%   to determine the value of the Incomplete Elliptic Integrals 
%   of the First, Second Kind and Jacobi's Zeta Function [1], [2].
%
%       F(phi,m) = int(1/sqrt(1-m*sin(t)^2), t=0..phi);
%       E(phi,m) = int(sqrt(1-m*sin(t)^2), t=0..phi);
%       Z(phi,m) = E(u,m) - E(m)/K(m)*F(phi,m).
%
%   Tables generating code ([1], pp. 613-621):
%       [phi,alpha] = meshgrid(0:5:90, 0:2:90);                  % modulus and phase in degrees
%       [F,E,Z] = elliptic12(pi/180*phi, sin(pi/180*alpha).^2);  % values of integrals
%
%   See also ELLIPKE, ELLIPJ, ELLIPTIC3, THETA, AGM.
%
%   References:
%   [1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical Functions", 
%       Dover Publications", 1965, Ch. 17.1 - 17.6 (by L.M. Milne-Thomson).
%   [2] D. F. Lawden, "Elliptic Functions and Applications"
%       Springer-Verlag, vol. 80, 1989

%   For support, please reply to 
%       moiseev[at]sissa.it
%       Moiseev Igor, 
%       34106, SISSA, via Beirut n. 2-4,  Trieste, Italy

if nargin<3, tol = eps; end
if nargin<2, error('Not enough input arguments.'); end

if ~isreal(u) | ~isreal(m)
    error('Input arguments must be real.')
end

if length(m)==1, m = m(ones(size(u))); end
if length(u)==1, u = u(ones(size(m))); end
if ~isequal(size(m),size(u)), error('U and M must be the same size.'); end

F = zeros(size(u)); 
E = F;              
Z = E;
m = m(:).';    % make a row vector
u = u(:).';

if any(m < 0) | any(m > 1), error('M must be in the range 0 <= M <= 1.'); end

I = uint32( find(m ~= 1 & m ~= 0) );
if ~isempty(I)
    [mu,J,K] = unique(m(I));   % extracts unique values from m
    K = uint32(K);
    mumax = length(mu);
    signU = sign(u(I));

    % pre-allocate space and augment if needed
	chunk = 7;
	a = zeros(chunk,mumax);
	c = a; 
	b = a;
	a(1,:) = ones(1,mumax);
	c(1,:) = sqrt(mu);
	b(1,:) = sqrt(1-mu);
	n = uint32( zeros(1,mumax) );
	i = 1;
	while any(abs(c(i,:)) > tol)                                    % Arithmetic-Geometric Mean of A, B and C
        i = i + 1;
        if i > size(a,1)
          a = [a; zeros(2,mumax)];
          b = [b; zeros(2,mumax)];
          c = [c; zeros(2,mumax)];
        end
        a(i,:) = 0.5 * (a(i-1,:) + b(i-1,:));
        b(i,:) = sqrt(a(i-1,:) .* b(i-1,:));
        c(i,:) = 0.5 * (a(i-1,:) - b(i-1,:));
        in = uint32( find((abs(c(i,:)) <= tol) & (abs(c(i-1,:)) > tol)) );
        if ~isempty(in)
          [mi,ni] = size(in);
          n(in) = ones(mi,ni)*(i-1);
        end
	end
     
    mmax = length(I);
	mn = double(max(n));
	phin = zeros(1,mmax);     C  = zeros(1,mmax);    
	Cp = C;  e  = uint32(C);  phin(:) = signU.*u(I);
	i = 0;   c2 = c.^2;
	while i < mn                                                    % Descending Landen Transformation 
        i = i + 1;
        in = uint32(find(n(K) > i));
        if ~isempty(in)     
            phin(in) = atan(b(i,K(in))./a(i,K(in)).*tan(phin(in))) + ...
                pi.*ceil(phin(in)/pi - 0.5) + phin(in);
            e(in) = 2.^(i-1) ;
            C(in) = C(in)  + double(e(in(1)))*c2(i,K(in));
            Cp(in)= Cp(in) + c(i+1,K(in)).*sin(phin(in));  
        end
	end
    
    Ff = phin ./ (a(mn,K).*double(e)*2);                                                      
    F(I) = Ff.*signU;                                               % Incomplete Ell. Int. of the First Kind
    Z(I) = Cp.*signU;                                               % Jacobi Zeta Function
    E(I) = (Cp + (1 - 1/2*C) .* Ff).*signU;                         % Incomplete Ell. Int. of the Second Kind
end

% Special cases: m == {0, 1}
m0 = find(m == 0);
if ~isempty(m0), F(m0) = u(m0); E(m0) = u(m0); Z(m0) = 0; end

m1 = find(m == 1);
um1 = abs(u(m1)); 
if ~isempty(m1), 
    N = floor( (um1+pi/2)/pi );  M = find(um1 < pi/2);              
    J = find(um1 >= pi/2);
    
    F(m1(M)) = log(tan(pi/4 + u(m1(M))/2));   
    F(m1(J)) = Inf;
    
    E(m1) = ((-1).^N .* sin(um1) + 2*N).*sign(u(m1)); 
    
    Z(m1) = tanh(u(m1));                      
    J = find(um1 > pi/2);
    Z(m1(J)) = NaN;
end
return;


function [a,b,c,n] = agm(a0,b0,c0,tol)
% AGM calculates the Artihmetic Geometric Mean of A and B (see [1]). 
% The function is used in routines ELLIPJ and ELLIPTIC12.
%
%   [A,B,C,N] = AGM(A0,B0,C0,TOL) carry out the process of the arithmetic geometric 
%   mean, starting with a given positive numbers triple (A0,B0,C0) and returns in 
%   (A,B,C) the generated sequence. N is a number of steps (returns in the type uint32).
%
%   The general scheme of the process:
%       A(i) = 1/2*( A(i-1)+B(i-1) );     A(0) = A0;
%       B(i) = sqrt(A(i-1)*B(i-1));       B(0) = B0;
%       C(i) = 1/2*( A(i-1)+B(i-1) );     C(0) = C0;
%   Stop at the N-th step when A(N) = B(N), i.e., when C(N) = 0.
%
%   See also ELLIPKE, ELLIPJ, ELLIPTIC12, ELLIPTIC3, THETA.
%
%   References:
%   [1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical
%       Functions" Dover Publications", 1965, Ch. 17.1 - 17.6.


if nargin<4, tol = eps; end
if nargin<3, error('Not enough input arguments.'); end

% pre-allocate space and augment if needed
chunk = 8; mmax = prod(size(a0));
a = zeros(chunk,mmax);
c = a;
b = a;
a(1,:) = a0;
b(1,:) = b0;
c(1,:) = c0;
n = uint32( zeros(1,mmax) );
i = 1;
while any(abs(c(i,:)) > tol)
    i = i + 1;
    if i > size(a,1)
      a = [a; zeros(chunk,mmax)];
      b = [b; zeros(chunk,mmax)];
      c = [c; zeros(chunk,mmax)];
    end
    a(i,:) = 0.5 * (a(i-1,:) + b(i-1,:));
    b(i,:) = sqrt(a(i-1,:) .* b(i-1,:));
    c(i,:) = 0.5 * (a(i-1,:) - b(i-1,:));
    in = uint32( find((abs(c(i,:)) <= tol) & (abs(c(i-1,:)) > tol)) );
    if ~isempty(in)
      [mi,ni] = size(in);
      n(in) = ones(mi,ni)*(i-1);
    end
end
return;