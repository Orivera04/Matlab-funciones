function LT = MaskManager(LT,I,J,flag)
%MASKMANAGER Sets the locks for cglookuptwo.
%   LT = MaskManager(LT,I,J,flag)
% I is the row index.  Use 0 for "all rows"
% J is the column index.  Use 0 for "all columns"
% flag is one of:
%   1 - Lock/unlock things
%   4 - unlock

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:11:20 $

switch flag
case {1, 'lock'}
   LT = i_lock(LT,I,J,1);
case {4, 'unlock'}
   LT = i_lock(LT,I,J,0);
end

% -----------------------------------------------------
% lock is 1 for "lock", 0 for "unlock".
function LT = i_lock(LT,I,J,lock)
% -----------------------------------------------------
L = get(LT,'vlocks');
V = get(LT,'values');
sizeLT = size(V);
if isempty(L);
   L = zeros(sizeLT);
end
% if either index is zero, convert it to "all indices".
% this will only have the desired effect if the other is a non-zero scalar.
if isequal(I,0)
   I = 1:sizeLT(1);
end
if isequal(J,0)
   J = 1:sizeLT(2);
end
sizeSel(1) = length(I);
sizeSel(2) = length(J);
if lock==1
    L(I,J) = 1;
else
    L(I,J) = 0;
end
LT = set(LT,'locks',L);