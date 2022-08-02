%FOR 	Repeat statements a specific number of times.
%	The general form of a FOR statement is:
% 
% 	   FOR variable = expr, statement, ..., statement END
% 
% 	The columns of the expression are stored one at a time in
% 	the variable and then the following statements, up to the
% 	END, are executed. The expression is often of the form X:Y,
% 	in which case its columns are simply scalars. Some examples
% 	(assume N has already been assigned a value).
% 
% 	     FOR I = 1:N,
% 	         FOR J = 1:N,
% 	             A(I,J) = 1/(I+J-1);
% 	         END
% 	     END
% 
% 	FOR S = 1.0: -0.1: 0.0, END steps S with increments of -0.1
% 	FOR E = EYE(N), ... END  sets E to the unit N-vectors.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
