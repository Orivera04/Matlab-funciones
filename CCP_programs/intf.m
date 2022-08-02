function y=intf(x)
% Integrates the function fun(t) from 0 to x.
% fun must be defined in an m-file in the path.

% If x is a vector of right end points for the
% interval, a vector of areas under the fun curve
% is returned in vector y.

for k=1:max(size(x))
   y(k)=quad8('fun',0,x(k));
end
