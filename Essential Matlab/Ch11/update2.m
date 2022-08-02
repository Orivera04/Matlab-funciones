K = 0.05;
F = 10;
a = 0;                % initial time
b = 100;              % final time
load train
dt = input( 'dt: ' );
opint = input( 'output interval (minutes): ' );
if opint/dt ~= fix(opint/dt)
  sound(y, Fs)
  disp( 'output interval is not a multiple of dt!' )
  break
end;

m = (b - a) / dt;     % m steps of length dt
if fix(m) ~= m        % make sure m is integer
  sound(y, Fs)
  disp( 'm is not an integer - try again!' );
  break
end;

T = zeros(1,m+1);     % pre-allocate (m+1) elements
time = a:dt:b;
T(1) = 25;            % initial temperature

for i = 1:m
  T(i+1) = T(i) - K * dt * (T(i) - F);
end;

disp( [time(1:opint/dt:m+1)' T(1:opint/dt:m+1)'] )
plot(time, T),grid
