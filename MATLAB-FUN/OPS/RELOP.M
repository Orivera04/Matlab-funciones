% < > Relational operators.
%     The six relational operators are <, <=, >, >=, ==, and ~=.
%     A < B does element by element comparisons between A and B
%     and returns a matrix of the same size with elements set to one
%     where the relation is true and elements set to zero where it is
%     not.  A and B must have the same dimensions unless one is a
%     scalar. A scalar can be compared with anything.
%
% &   Logical AND.
%     A & B is a matrix whose elements are 1's where both A and B
%     have non-zero elements, and 0's where either has a zero element.
%     A and B must have the same dimensions unless one is a scalar.
%     A scalar can be operate with anything.
%
% |   Logical OR.
%     A | B is a matrix whose elements are 1's where either A or B
%     has a non-zero element, and 0's where both have zero elements.
%     A and B must have the same dimensions unless one is a scalar.
%     A scalar can be operate with anything.
%
% ~   Logical complement (NOT).
%     ~A is a matrix whose elements are 1's where A has zero
%     elements, and 0's where A has non-zero elements.
%
% xor Exclusive OR.
%     xor(A,B) is 1 where either A or B, but not both, is non-zero.
%
%	See also XOR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
