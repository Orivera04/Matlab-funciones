% repeat3.m
% repeated value creation and counting

%x = [3 2 0 5 6];  % data to repeat
%n = [2 0 3 1 2];  % repeat counts

nz = n==0;            % locations of zero elements
n(nz) = [];           % eliminate zero counts
x(nz) = [];           % eliminate corresponding data

csn = cumsum(n);               % cumulative sum of counts
tmp = zeros(1,csn(end));       % preallocate memory
tmp([1 csn(1:end-1)+1]) = 1;   % poke in ones
idx = cumsum(tmp);             % index vector
y = x(idx);                    % let array indexing do the work
