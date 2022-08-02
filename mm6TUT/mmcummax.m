function k=mmcummax(x,arg)
%MMCUMMAX Indices of Cumulative Maxima. (MM)
% MMCUMMAX(X) or MMCUMMAX(X,'max') returns the indices of 
% cumulative maxima in X(:).
% That is, an index value i is returned if X(i)>X(1:i-1).
%
% MMCUMMAX(X,'min') returns the indices of cumulative minima
% in X(:). That is, an index value i is returned if X(i)<X(1:i-1).

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/28/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2
   arg='max';
end
x=x(:)';
if isempty(x)|~isreal(x)
   error('Input Must be Non-Empty and Real-Valued.')
end
k=zeros(size(x));       % preallocate space for result
k(1)=1;                 % first value goes in by default
if strcmpi(arg,'min')   % cumulative minima requested
   x=-x;
end
while 1
   good=find(k);           % all mmcummax indices known
   last=good(end);         % largest index now
   i=find(x(k(last))<x);   % find next index
   if ~isempty(i)          % next value exists
      k(last+1)=i(1);      % poke it into k
   else                    % none exist, we're done
      k=k(good);           % take only found values
      break
   end
end
