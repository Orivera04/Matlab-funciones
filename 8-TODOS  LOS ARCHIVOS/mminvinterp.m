function [xo,yo]=mminvinterp(x,y,yo)
%MMINVINTERP 1-D Inverse Interpolation.
% [Xo, Yo]=MMINVINTERP(X,Y,Yo) linearly interpolates the vector Y to find
% the scalar value Yo and returns all corresponding values Xo interpolated
% from the X vector. Xo is empty if no crossings are found. For
% convenience, the output Yo is simply the scalar input Yo replicated so
% that size(Xo)=size(Yo).
% If Y maps uniquely into X, use INTERP1(Y,X,Yo) instead.
%
% See also INTERP1.

if nargin~=3
   error('Three Input Arguments Required.')
end
n = numel(y);
if ~isequal(n,numel(x))
   error('X and Y Must have the Same Number of Elements.')
end
if ~isscalar(yo)
   error('Yo Must be a Scalar.')
end

x=x(:); % stretch input vectors into column vectors
y=y(:);

if yo<min(y) || yo>max(y) % quick exit if no values exist
   xo = [];
   yo = [];
else                      % find the desired points
   
   below = y<yo;          % True where below yo 
   above = y>=yo;         % True where at or above yo
   
   kth = (below(1:n-1)&above(2:n))|(above(1:n-1)&below(2:n)); % point k
   kp1 = [false; kth];                                        % point k+1
   
   alpha = (yo - y(kth))./(y(kp1)-y(kth));% distance between x(k+1) and x(k)
   xo = alpha.*(x(kp1)-x(kth)) + x(kth);  % linearly interpolate using alpha
   
   yo = repmat(yo,size(xo)); % duplicate yo to match xo points found
end 
