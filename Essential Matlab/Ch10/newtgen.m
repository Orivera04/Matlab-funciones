% Newton's method in general
% exclude zero roots!

steps = 0;                         % iteration counter
x = input( 'Initial guess: ' );    % estimate of root
re = 1e-8;                         % required relative error
myrel = 1;

while myrel > re & (steps < 20)
  xold = x;
  x = x - f(x)/df(x);
  steps = steps + 1;
  disp( [x f(x)] )
  myrel = abs((x-xold)/x);
end;

if myrel <= re
  disp( 'Zero found at' )
  disp( x )
else
  disp( 'Zero NOT found' )
end;