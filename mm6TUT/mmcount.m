function [y,n]=mmcount(a,s)
%MMCOUNT Count Occurances of Values in an Array. (MM)
% [Y,N]=MMCOUNT(A,S) returns vectors Y and N where Y contains
% the sorted unique values in A and N(i) contains the number
% of occurances of A(i) in S. A and S must be real arrays.
%
% N=MMCOUNT(A,S) returns only the counts in N.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/5/99, 12/30/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isreal(a)|~isreal(s)
   error('A and S Must be Real.')
end
if any(isnan(a))|any(isinf(a))
   error('A Must Not Contain NaNs or Infs.')
end
isrow=(size(a,1)==1);
y=sort(a(:));
y(~[diff(y);1])=[];  % discard duplicate values in a

% slower method because of second sort
% s=s(ismember(s,y));  % discard nonmembers from s
% ys=sort([y; s(:)]);  % use algorithm from MMREPEAT
% n=diff([find([1;diff(ys)]~=0); length(ys)+1])-1;

[f,e]=log2(y);
edges=zeros(1,2*length(y));
edges(1:2:end-1)=y;
edges(2:2:end)=pow2(f+eps,e); % just a bit above a
n=histc(s(:),edges);
n=n(1:2:end-1);
if isrow
   y=y.';
   n=n.';
end
if nargout<2
   y=n;
end