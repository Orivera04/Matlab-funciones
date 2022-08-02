function a2 = repmat2(a, sizeB, rcA, rcB)
%REPMAT2  Replicating a matrix to be added to or multiplied by a N-D array
%   A2 = REPMAT2(A, SIZEB, RCA, RCB) is an array containing multiple copies
%   of matrix A (see REPMAT). The size of A2 is such that it can be added
%   to, or multi-multiplied by (with function MULTIPROD) an array B of 
%   size SIZEB.
%
%   A       A matrix (2-D array).
%   SIZEB   The size of array B.
%   RCA     The dimension(s) of matrix A to be replicated (1, 2 or [1 2]).
%           If RCA is 1,     A must be M-by-1. 
%           If RCA is 2,     A must be 1-by-N.
%           If RCA is [1 2], A may be M-by-N or M-by-1 or 1-by-N or 1-by-1.
%   RCB     The dimension(s) of array B along which the subarrays to be
%           added to or multiplied by A are found (D or [D D+1]).
%
%   Examples:
%   1) If A is ...................................... a MxN  matrix
%      and SIZEB is [P Q R N S], i.e. B is ... a PxQxRx(NxS) array,
%      A2 = REPMAT2(A, SIZEB, [1 2], [4 5]) is a PxQxRx(MxN) array.
%      It is now possible to use C = MULTIPROD(A2, B, [4 5]) or C = A2 + B.
%
%   2) If A is ................................. a 1x(N) matrix
%      and SIZEB is [P Q R N S], i.e. B is a PxQxRx(NxS) array,
%      A2 = REPMAT2(A, SIZEB, 2, [4 5]) is a PxQxRx(N)   array.
%      It is now possible to use C = MULTIPROD(A2, B, 4, [4 5]).
%
%   See also REPMAT, MULTIPROD.

% $ Version: 1.0 $
% CODE      by:                 Paolo de Leva (IUSM, Rome, IT) 2005 Oct 11
% COMMENTS  by:                 Code author                    2005 Oct 11
% OUTPUT    tested by:          Code author                    2005 Oct 11
% -------------------------------------------------------------------------

% Processing RCA
if rcA == 1
    ins = 1;
elseif rcA == 2
    a = a';
    ins = 1;
elseif rcA == [1 2]
    ins = [1 1];    
end

if numel(rcA) == 1 & size(a, 2) > 1
    error('repmat2:NAsizeOfA', ['If RCA is 1, A must be M-by-1.\n' ...
                                'If RCA is 2, A must be 1-by-N' ]);
end

% Processing RCB
d1 = rcB(1);
if numel(rcB) == 1
    d2 = d1;
elseif numel(rcB) == 2
    d2 = rcB(2);
end

% Adjusting the size of A                       % Example:
a = reshape(a, [ones(1,d1-1), size(a)]);        % A      is 1x1x1x(MxN)
basize = [sizeB(1:d1-1), ins, sizeB(d2+1:end)]; % BASIZE is PxQxRx(1x1)
a2 = repmat(a, basize);                         % A2     is PxQxRx(MxN)
