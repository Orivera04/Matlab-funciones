%SCHUR	Schur decomposition.
%	[U,T] = SCHUR(X) produces a Schur matrix T and a unitary
%	matrix U so that X = U*T*U' and U'*U = EYE(U).
% 	By itself, SCHUR(X) returns T.
% 	If X is complex, the Complex Schur Form is returned in matrix T.
% 	The Complex Schur Form is upper triangular with the eigenvalues
% 	of X on the diagonal.
% 	If X is real, the Real Schur Form is returned.  The Real Schur
% 	Form has the real eigenvalues on the diagonal and the complex
% 	eigenvalues in 2-by-2 blocks on the diagonal.
% 	See RSF2CSF to convert from Real to Complex Schur form.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
