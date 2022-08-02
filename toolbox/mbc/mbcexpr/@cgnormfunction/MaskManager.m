function LT = MaskManager(LT,I,J,flag)
%MASKMANAGER Sets locks for a cgnormfunction.
%    LT = MaskManager(LT,I,J,flag)
% I is the row index.  Use 0 for "all rows".
% J is unused, and is present for compatibility with cglookuptwo.
% flag is one of:
%   1 - lock
%   4 - unlock

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:14:27 $

switch flag
case {1, 'lock'}
    LT = i_lock(LT,I,J);
case {4, 'unlock'}
    LT = i_unlock(LT,I,J);
end

% --------------------------------------------------
function LT = i_lock(LT,I,J)
% --------------------------------------------------
VL = get(LT,'vlocks');
val = get(LT,'values');
n = length(val);
if isempty(VL);
    VL = zeros(n,1);
end
if isequal(I,0)
    I = 1:n; % Whole column to be locked
end
sizeSel = length(I);
if all(VL(I))
    VL(I) = zeros(sizeSel,1);
else
    VL(I) = ones(sizeSel,1);
end
LT = set(LT,'vlocks',VL);


% --------------------------------------------------
function LT = i_unlock(LT,I,J)
% --------------------------------------------------
VL = get(LT,'vlocks');
val = get(LT,'values');
n = length(val);
if isempty(VL);
    VL = zeros(n,1);
end
if isequal(I,0)
    I = 1:n; % Whole column to be locked
end
sizeSel = length(I);
VL(I) = zeros(sizeSel,1);
LT = set(LT,'vlocks',VL);

