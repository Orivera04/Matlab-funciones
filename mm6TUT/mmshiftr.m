function y=mmshiftr(a,n,cs)
%MMSHIFTR Shift or Circularly Shift Matrix Columns. (MM)
% MMSHIFTR(A,N) with N>0 shifts the columns of A to the RIGHT N columns.
% The first N columns are replaced by zeros and the last N
% columns of A are deleted.
% 
% MMSHIFTR(A,N) with N<0 shifts the columns of A to the LEFT N columns.
% The last N columns are replaced by zeros and the first N
% columns of A are deleted.
% 
% MMSHIFTR(A,N,C) where C is nonzero performs a circular
% shift of N columns, where columns circle back to the
% other side of the matrix. No columns are replaced by zeros.
%
% See also MMSHIFTD.

% Calls: mmshiftd

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/24/95, renamed 5/22/96, v5: 1/13/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3,cs=0;end
if ndims(a)~=2
	error('Input Must be 2D.')
end
y=(mmshiftd(a.',n,cs)).';
