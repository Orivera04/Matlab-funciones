% P12_32.M Compute Normal distribution
% INPUTS: mean, standard deviation, limits
%  Call normdist to compute value
mean=input('Mean value u= ');
stdev=input('Standard deviation s= ');
lowx=input('Lower limit = ');
highx=input('Upper limit = ');
prob=normdist(mean,stdev,lowx,highx);
fprintf('The probability is %d\n',prob)