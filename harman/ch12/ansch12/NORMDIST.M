function prob=normdist(mean,stdev,lowx,highx)
% CALL: prob=normdist(mean,stdev,lowx,highx)
%   compute normal distribution with mean= mean and
%   standard deviation stdev between lowx and highx
z='(x-mean)/stdev';
intg='exp(-z^2/2)/sqrt(2*pi)';
prob=numeric(int(intg,lowx,highx));