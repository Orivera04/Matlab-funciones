% subdiv1.m
% subdivide a vector

x=[4 5 7 6]; % test data
n=4;         % number of subdivisions

N=length(x); % length of data

y=zeros(1,N+(n-1)*(N-1)); % preallocate result
f=(0:n-1)/n; % fractional spacing between elements
idx=1;       % index for result

for i=1:n-1
   dx=x(i+1)-x(i);             % difference
   y(idx:idx+(n-1))=x(i)+f*dx; % place values
   idx=idx+n;                  % update index
end
y(end)=x(end); % place last value