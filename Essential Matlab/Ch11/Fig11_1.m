K = input( 'K' );
F = 10;
a = 0;                % start time
b = 100;              % end time
bell = setstr(7);

dt = input( 'dt: ' );
%opint = input( 'output interval (minutes): ' );
%7if opint/dt ~= fix(opint/dt)
%  disp(bell)
%  disp( 'output interval is not a multiple of dt - try again!' );
%  break
%end;

m = (b - a) / dt;     % m steps of length dt
if fix(m) ~= m        % make sure m is integer
  disp(bell)
  disp( 'm is not an integer - try again!' );
  break
end;

T = zeros(1,m+1);     % pre-allocate
time = a:dt:b;

T(1) = 25;            % initial temperature

for i = 1:m           
  T(i+1) = T(i) - K * dt * (T(i) - F);
end;

%disp( [time(1:opint/dt:m+1)' T(1:opint/dt:m+1)'] )   % vectors have m+1 elements

plot(time, T),xlabel('Time (minutes)'), ylabel('Temperature (degrees C)'),gtext( sprintf('K = %5.3f', K) )
