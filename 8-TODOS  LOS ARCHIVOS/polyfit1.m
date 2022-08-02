% polyfit1.m 
% find polynomial coefficients without polyfit

x = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1]';
y = [-.447 1.978 3.28 6.16 7.08 7.34 7.66 9.56 9.48 9.30 11.2]';
n = 2;

pm = polyfit(x,y,n) % MATLAB polyfit result

% create Vandermonde matrix using code from vander3.m
m = length(x);   % number of elements in x
V = ones(m,n+1); % preallocate memory for result
for i=n:-1:1     % build V column by column
   V(:,i) = x.*V(:,i+1);
end

p = (V\y)'