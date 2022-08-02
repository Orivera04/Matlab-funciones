function [xo,mask] = lininsrt(x,n)

% LININSRT Linear insertion between neighboring points.
%	[XO,MASK] = LININSRT(X,N) Inserts N points
%	between each two points of the input vector X.
%	N can be a number or a vector with the length
%	equal to length(X)-1.
%	Returns output vector XO with inserted points
%	and vector MASK of the same size as XO with
%	0 for old elements and for new ones.

%  Kirill Pankratov, kirill@plume.mit.edu
%  01/16/95

 % Handle input ...................................
if nargin<2, n = 1; end
szx = size(x);
n = n(:);
ln = length(n);

if ln==1 % If scalar, make a uniform vector
  c = szx(1)==1;
  c = (~c)*szx(1)+c*szx(2)-1;
  n = n(ones(c,1)); ln = c;
end

 % Check that length of n be equal to the number of
 % columns or number of rows of x minus 1.
c = (ln==szx-1);
if ~any(c)
  error(' Second argument length must be size(x,1)-1')
end
c = c(2)-c(1);

if ~any(n)  % If no points to be inserted
  xo = x;
  if c>0, mask = zeros(1,szx(2));
  else, mask = zeros(szx(1),1);
  end
  return
end

 % Check if transposition is needed
is_transpose = 0;
if c>0
  x = x';
  is_transpose = 1;
end
szx = size(x);

 % Check that all values of n are finite and
 % non-negative.
mask = find( ~finite(n) | n<0 );
n(mask) = zeros(size(mask));


 % Calculate old and new intervals dx and dxo ........
dx = diff(x);
n = n+1;
dxo = dx./n(:,ones(1,szx(2)));
n = [1; cumsum(n)+1];
lxo = n(szx(1));  % Length of the output vector

 % Calculate mask .............................
mask = zeros(lxo,1);
mask(n) = ones(size(n));
a = cumsum(mask);

 % Calculate output vector (or matrix) ........
n = ones(lxo-1,1);
xo = [x(1,:); x(n,:)+cumsum(dxo(a(1:lxo-1),:))];

 % Make sure "old" values of x are exact
 % (possible round-off error)
xo(mask,:) = x;

mask = ~mask; % Invert mask (1 - for new points)

 % Transpose back if necessary ................
if is_transpose
  xo = xo';
  mask = mask';
end

