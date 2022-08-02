% L5_2.m.  See Eample 5.2.
% Copyright S. Nakamura, 1995
clear;   Iexact = 4.006994;
a = 0; b=2;
fprintf('\n Extended Trapezoidal Rule\n');
fprintf('\n      n      I             Error\n');
n = 1;
for k=1:6
   n = 2*n;
   h = (b-a)/n;   i = 1:n+1;
   x = a + (i-1)*h;   f = sqrt(1 + exp(x));
   I =  trapez_v(f,h);
   fprintf('    %3.0f   %10.5f    %10.5f\n', ...
                   n,   I,   Iexact - I);
end

