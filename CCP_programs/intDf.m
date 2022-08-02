function y=intDf(x)
% Integrates the function Dfun(t) from 0 to x.
% Dfun must be defined in an m-file in the path.

% If x is a vector of right end points for the
% interval, a vector of areas under the fun curve
% is returned in vector y.

for k=1:max(size(x))
  y(k)=quad8('Dfun',0,x(k));
end
