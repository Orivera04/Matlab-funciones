function [time, T, m] = cooler( a, b, K, F, dt, T0 )

load train
m = (b - a) / dt;     % m steps of length dt
if fix(m) ~= m        % make sure m is integer
  sound(y, Fs)
  disp( 'm is not an integer - try again!' );
  break
end;

T = zeros(1,m+1);     % pre-allocate
time = a:dt:b;
T(1) = T0;            % initial temperature

for i = 1:m
  T(i+1) = T(i) - K * dt * (T(i) - F);
end;
