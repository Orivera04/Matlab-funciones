% repeat4.m
% repeated value creation and counting

%x = [3 2 0 5 6];  % data to repeat
%n = [2 0 3 1 2];  % repeat counts

nz=(n~=0);
n=n(nz);            % eliminate zero counts
x=x(nz);            % eliminate corresponding data

csn=cumsum(n);             % cumulative sum of counts
y=zeros(1,csn(end));       % preallocate memory once!
y([1 csn(1:end-1)+1]) = 1; % poke in ones
y(:)=cumsum(y);            % index vector
y(:)=x(y);                 % let array indexing do the work
