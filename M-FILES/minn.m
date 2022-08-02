function [mn,idx,col]=minn(A)
%MINN N-D Array Minimum.
% MINN(A) returns the minimum value found in the array A.
%
% [MN,Row,Col] = MINN(A) for 2-D A returns the minimum value MN as well as
% the row and column subscripts where the minimum appears. Row and Col are
% column vectors if multiple minimums appear in A.
%
% [MN,Idx] = MINN(A) returns the minimum value MN as well as the linear
% indices Idx of all elements in A that are equal to MN.
% To get the row, column, ..., subscripts associated with the linear indices
% use IND2SUB(size(A),Idx).

% 2004-04-06
% D.C. Hanselman, University of Maine, Orono, ME  04469-5708

if ~isnumeric(A)
   error('Numeric Input Expected.')
end
mn=min(A(:));

if nargout==2                   % [MN,idx]=MINN(A)
   idx=find(A==mn);
   
elseif nargout==3 & ndims(A)==2 % [MN,Row,Col]=MINN(A)
   [idx,col]=ind2sub(size(A),find(A==mn));
   
elseif nargout==3
   error('Three Output Arguments Requires 2-D Input.')
end
