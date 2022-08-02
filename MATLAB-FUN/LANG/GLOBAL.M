%GLOBAL	Define global variables.
% 	GLOBAL X Y Z defines X, Y, and Z as global in scope.
%
%	Ordinarily, each MATLAB function, defined by an M-file, has its
%	own local variables, which are separate from those of other functions,
%	and from those of the base workspace and non-function scripts.
%	However, if several functions, and possibly the base workspace,
%	all declare a particular name as GLOBAL, then they all share
%	a single copy of that variable.  Any assignment to that variable,
%	in any function, is available to all the other functions declaring
%	it GLOBAL.
%
%	Stylistically, global variables often have long names with all
%	capital letters, but this is not required.
%
%	For an example, see the functions TIC and TOC.
%
%	See also ISGLOBAL, CLEAR, WHO.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.
