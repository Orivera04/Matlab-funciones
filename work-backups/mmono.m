function f=mmono(x)
%MMONO Test for Monotonic Vector. (MM)
% MMONO(X) where X is a vector returns:
%     2 if X is strictly increasing,
%     1 if X is non decreasing,
%    -1 if X is non increasing,
%    -2 if X is strictly decreasing,
%     0 otherwise.
%
% See also DIFF, ALL

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 2/7/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

x=x(:);			% make x a vector
y=diff(x);		% find differences between consecutive elements

if all(y>0)	% test for strict first
   f=2;
elseif all(y>=0)
   f=1;
elseif all(y<0)	% test for strict first
   f=-2;
elseif all(y<=0)
   f=-1;
else  % default response
   f=0;
end
