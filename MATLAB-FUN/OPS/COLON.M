% :   Colon. Used in subscripts, FOR iterations and possibly elsewhere.
%
%     J:K  is the same as [J, J+1, ..., K]
%     J:K  is empty if J > K.
%     J:D:K  is the same as [J, J+D, ..., J+m*D] where m = fix((K-J)/D).
%     J:D:K  is empty if D > 0 and J > K or if D < 0 and J < K.
%
%     The colon notation can be used to pick out selected rows,
%     columns and elements of vectors and matrices.
%     A(:) is all the elements of A, regarded as a single
%     column. On the left side of an assignment statement, A(:)
%     fills A, preserving its shape from before.
%     A(:,J) is the J-th column of A
%     A(J:K) is A(J),A(J+1),...,A(K)
%     A(:,J:K) is A(:,J),A(:,J+1),...,A(:,K) and so on.
%
%     For the use of the colon in the FOR statement, See FOR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
