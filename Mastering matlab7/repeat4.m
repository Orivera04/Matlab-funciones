% repeat4.m
% repeated value creation and counting
% inverse operation

%y = [3 3 0 0 0 5 6 6]; % data to examine

x = y(1);              % beginning data
n = 1;                 % beginning count
idx = 1;               % index value
for i=2:length(y)
   if y(i)==x(idx)     % value matches current x
      
      n(idx) = n(idx)+1; % increment current count
      
   else                % new value found
      
      idx = idx+1;       % increment index
      x(idx) = y(i);     % poke in new x
      n(idx) = 1;        % start new count
   end
end