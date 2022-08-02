%WHILE	Repeat statements an indefinite number of times.
%	The general form of a WHILE statement is:
% 
% 	   WHILE variable, statement, ..., statement, END
% 
% 	The statements are executed while the variable has all
% 	non-zero elements. The variable is usually the result of
% 	expr rop expr where rop is ==, <, >, <=, >=, or ~=.
% 	For example (assuming A already defined):
% 
% 	        E = 0*A; F = E + EYE(E); N = 1;
% 	        WHILE NORM(E+F-E,1) > 0,
% 	           E = E + F;
% 	           F = A*F/N;
% 	           N = N + 1;
% 	        END

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
