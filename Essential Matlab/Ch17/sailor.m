% random walk
n = input( 'Number of walks: ' );
tic
nsafe = 0;                  % number of times he makes it

for i = 1:n
  steps = 0;                % each new walk ...
  x = 0;                    % ... starts at the origin
  y = 0;

  while x <= 50 & abs(y) <= 10 & steps < 1000
    steps = steps + 1;      % that's another step
    r = rand;               % random number for that step
    if r < 0.6              % which way did he go?
      x = x + 1;            % maybe forward ...
    elseif r < 0.8
      y = y + 1;            % ... or to port ...
    else
      y = y - 1;            % ... or to starboard
    end;
  end;

  if x > 50
      nsafe = nsafe + 1;      % he actually made it this time!
  end;

end;

toc
prob = 100 * nsafe / n;
disp( prob );