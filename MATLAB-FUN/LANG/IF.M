%IF  	Conditionally execute statements.
%	The general form of an IF statement is:
% 	        IF variable, statements, END
% 	The statements are executed if the real part of the variable 
% 	has all non-zero elements. The variable is usually the result of
% 	expr rop expr where rop is ==, <, >, <=, >=, or ~=.
% 	For example:
% 
% 	       IF I == J
% 	          A(I,J) = 2;
% 	       ELSEIF ABS(I-J) == 1
% 	          A(I,J) = -1;
% 	       ELSE
% 	          A(I,J) = 0;
% 	       END

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
