% repeat2.m
% repeated value creation and counting

x = [3 2 0 5 6];  % data to repeat
n = [2 0 3 1 2];  % repeat counts

nz = n==0;            % locations of zero elements
n(nz) = [];           % eliminate zero counts
x(nz) = [];           % eliminate corresponding data
y = zeros(1,sum(n));  % preallocate array

idx = 1;                     % pointer into y
for i=1:length(x)
   y(idx:idx+n(i)-1) = x(i); % poke data into y
   idx = idx+n(i);           % next storage location
end
y