function [mx,idx,col]=maxn(A)
%MAXN N-D Array Maximum.
% MAXN(A) returns the maximum value found in the array A.
%
% [MX,Row,Col] = MINN(A) for 2-D A returns the maximum value MX as well as
% the row and column subscripts where the maximum appears. Row and Col are
% column vectors if multiple maximums appear in A.
%
% [MX,Idx] = MAXN(A) returns the maximum value MX as well as the linear
% indices Idx of all elements in A that are equal to MX.
% To get the row, column, ..., subscripts associated with the linear indices
% use IND2SUB(size(A),Idx).

% 2004-04-06
% D.C. Hanselman, University of Maine, Orono, ME  04469-5708

if ~isnumeric(A)
   error('Numeric Input Expected.')
end
mx=max(A(:));

if nargout==2                   % [MX,idx]=MAXN(A)
   idx=find(A==mx);
   
elseif nargout==3 & ndims(A)==2 % [MX,Row,Col]=MAXN(A)
   [idx,col]=ind2sub(size(A),find(A==mx));
   
elseif nargout==3
   error('Three Output Arguments Requires 2-D Input.')
end
