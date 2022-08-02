function theta = subspace(A,B)
%SUBSPACE Angle between two subspaces.
%	SUBSPACE(A,B) finds the angle between two subspaces specified
%	by the columns of A and B.  If A and B are vectors of unit
%	length, this is the same as ACOS(A'*B).
%	If the angle is small, the two spaces are nearly linearly
%	dependent.  In a physical experiment described by some
%	observations A, and a second realization of the experiment
%	described by B, SUBSPACE(A,B) gives a measure of the amount
%	of new information afforded by the second experiment not
%	associated with statistical errors of fluctuations.

%	L. Shure 11-03-88, CBM 5-3-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if size(A,1) ~= size(B,1)
   error('Row dimensions of A and B must be the same.')
end
[QA,ignore] = qr(A,0);
[QB,ignore] = qr(B,0);
s = svd(QA'*QB);
% The max singular value is the correct one to choose
% but should have magnitude no more than 1.
theta = acos(min(min(s),1));
