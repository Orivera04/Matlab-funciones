function k=mmpeaks(y,s)
%MMPEAKS Find Indices of Relative Extremes. (MM)
% MMPEAKS(Y,'max') return the indices where Y(:) has local maxima.
% MMPEAKS(Y,'min') returns the indices where Y(:) has local minima.
% MMPEAKS(Y,'all') returns the indices where Y(:) has either extreme.
% First and last data points are returned if appropriate.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 12/17/96, v5: 1/14/97, 9/1/97, 10/30/97, 3/28/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

ys=size(y)
x=reshape(y,1,prod(ys));
if ~isreal(x), error('Input Must be Real-Valued.'), end
if nargin==1, s='max'; end
s=lower(s);

if strncmp(s,'ma',2)     % MMPEAKS(Y,'max')
   k = sign(diff([-inf x -inf]));
   k = find(diff(k+(k==0))==-2);
   
elseif strncmp(s,'mi',2) % MMPEAKS(Y,'min')
   k = sign(diff([inf x inf]));
   k = find(diff(k+(k==0))==2);
   
elseif strncmp(s,'a',1)  % MMPEAKS(Y,'all')
   k = sort([mmpeaks(x,'max') mmpeaks(x,'min')]);
else
   error('Incorrect Second Input Argument.')
end
if ys(2)==1 % return row if row input
   k=k';
end