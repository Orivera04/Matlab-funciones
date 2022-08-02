format compact
n = 5;
k = 0.01;
h =  1 / (2 * n);                        % symmetry assumed
r = k / h ^ 2;

% set up the (sparse) matrix A
b = sparse(1:n, 1:n, 2+2*r, n, n);       % b(1) .. b(n)
c = sparse(1:n-1, 2:n, -r, n, n);        % c(1) .. c(n-1)
a = sparse(2:n, 1:n-1, -r, n, n);        % a(2) ..
A = a + b + c;
A(n, n-1) = -2 * r;                      % symmetry: a(n)
full(A)                                  %
disp(' ')

u0 = 0;                   % boundary condition (Eq 19.20)
u = 2*h*[1:n];            % initial conditions (Eq 19.21)
u(n+1) = u(n-1);          % symmetry
disp([0 u(1:n)])

for t = k*[1:10]
  g = r * ([u0 u(1:n-1)] + u(2:n+1)) ...
                         + (2 - 2 * r) * u(1:n);  % Eq 19.19
  v = A\g';               % Eq 19.24
  disp([t v'])
  u(1:n) = v;
  u(n+1) = u(n-1);        % symmetry
end