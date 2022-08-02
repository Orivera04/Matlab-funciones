function y = bubble( x )
n = length(x);
sorted = 0;             % flag to detect when sorted
k = 0;                  % count the passes

while ~sorted
  sorted = 1;           % they could be sorted
  k = k + 1;            % another pass
  for j = 1:n-k         % fewer tests on each pass
    if x(j) > x(j+1)    % are they in order?
      temp = x(j);      % no ...
      x(j) = x(j+1);
      x(j+1) = temp;
      sorted = 0;       % a swop was made
    end
  end
end;

y = x;
