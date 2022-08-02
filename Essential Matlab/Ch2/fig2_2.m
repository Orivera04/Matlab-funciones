% Vertical motion under gravity
g = 9.8;                      % acceleration due to gravity
u = 60;                       % initial velocity (metres/sec)
t = 0 : 0.1 : 12.3;           % time in seconds
s = u * t - g / 2 * t .^ 2;   % vertical displacement in metres

plot(t, s), title( 'Vertical motion under gravity' ), ...
     xlabel( 'time' ), ylabel( 'vertical displacement' ), grid
disp( [t' s'] )               % display a table