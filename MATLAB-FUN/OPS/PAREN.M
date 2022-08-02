% ( ) Parentheses are used to indicate precedence in arithmetic
%     expressions and to enclose arguments of functions in the
%     usual way. They are used to enclose subscripts of vectors
%     and matrices in a manner somewhat more general than the
%     usual way. If X and V are vectors, then X(V) is
%     [X(V(1)), X(V(2)), ..., X(V(N))]. The components of V
%     are rounded to nearest integers and used as subscripts. An
%     error occurs if any such subscript is less than 1 or
%     greater than the dimension of X. Some examples:
%     X(3) is the third element of X.
%     X([1 2 3]) is the first three elements of X. So is
%     X([SQRT(2), SQRT(3), 4*ATAN(1)]).
%     If X has N components, X(N:-1:1) reverses them.
%     The same indirect subscripting is used in matrices. If V
%     has M components and W has N components, then A(V,W)
%     is the M-by-N matrix formed from the elements of A whose
%     subscripts are the elements of V and W. For example...
%     A([1,5],:) = A([5,1],:) interchanges rows 1 and 5 of A.
%
% [ ] Brackets are used in forming vectors and matrices.
%     [6.9 9.64 SQRT(-1)] is a vector with three elements
%     separated by blanks. [6.9, 9.64, sqrt(-1)] is the same
%     thing. [1+I 2-I 3] and [1 +I 2 -I 3] are not the same.
%     The first has three elements, the second has five.
%     [11 12 13; 21 22 23] is a 2-by-3 matrix. The semicolon
%     ends the first row.
%     Vectors and matrices can be concatenated with [ ] brackets.
%     [A B; C] is allowed if the number of rows of A equals
%     the number of rows of B and the number of columns of A
%     plus the number of columns of B equals the number of
%     columns of C. This rule generalizes in a hopefully
%     obvious way to allow fairly complicated constructions.
%     A = [ ] stores an empty matrix in A. See CLEAR to remove
%     variables from the current workspace.
%     For the use of [ and ] on the left of the = in multiple
%     assignment statements, see LU, EIG, SVD and so on.

% Copyright (c) 1984-94 by The MathWorks, Inc.
