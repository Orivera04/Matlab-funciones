function [A, B] = pgetAB(sumst, astr, bstr)
% PGETAB Return the A and B matrices for linear constraints
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:37 $

%
% Number of non-zero points in the data set
%
os = sumst.os;
nzt = getNonZeroWtPts(sumst);
nNzt = length(nzt);

%
% A
%
A = get(os,astr);
newA = [];
for i = 1:size(A, 2)
    cellA(1:nNzt) = {A(:, i)};
    tempA = blkdiag(cellA{:});
    newA = [newA, tempA];
end
A = newA;

%
% B
%
B = get(os,bstr);
if ~isempty(B)
    B = repmat(B,nNzt, 1);
    B = B(:);
else
    B = [];
end
