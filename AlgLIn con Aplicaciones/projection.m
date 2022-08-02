function Apar = projection(a, b, dim)
%PROJECTION  Vector component of vector(s) A parallel to vector(s) B.
%   Apar = PROJECTION(A, B) is equivalent to Apar = PROJECTION(A, B, DIM),
%   where DIM is the first non-singleton dimension of A and B.
%
%   Apar = PROJECTION(A, B, DIM) returns the projection(s) of the vector(s)
%   contained in A on the axis (axes) along which the vector(s) in B lie. 
%   A and B are vectors (N-by-1 or 1-by-N) or arrays containing vectors
%   along dimension DIM. They must have the same size.
%
%   See also REJECTION.

% $ Version: 1.0 $
% CODE      by:                 Paolo de Leva (IUSM, Rome, IT) 2005 Oct 16
% COMMENTS  by:                 Code author                    2005 Oct 29
% -------------------------------------------------------------------------

% Setting DIM if not supplied.
if nargin == 2
   firstNS = min( find(size(a)>1) ); % First non-singleton dimension of A
                                     % (empty matrix if A is a scalar)
   dim = max([firstNS, 1]);          % DIM = 1 if A is a scalar
end

unitB = unit(b, dim);
scalarApar = dot(a, unitB, dim);
Apar = multiprod(unitB, scalarApar, dim);