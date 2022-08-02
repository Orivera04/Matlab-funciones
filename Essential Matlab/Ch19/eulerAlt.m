h = 0.5;
r = 0.8;
a = 0;
b = 10;
m = (b - a) / h;
N = zeros(1, m);     % one less element now
N0 = 1000;
N(1) = N0 + r*h*N0;  % no longer 'self-starting'

for i = 2:m
  N(i) = N(i-1) + r * h * N(i-1); %finite difference notation
end

t = a+h:h:b;         % exclude initial time = a
Nex = N0 * exp(r * t);
disp( [a N0 N0] )    % display initial values separately
disp( [t' N' Nex'] )

plot(a, N0)          % plot initial values separately
hold on
plot(t, N ), xlabel( 'Hours' ), ylabel( 'Bacteria' )
plot(t, Nex ), hold off