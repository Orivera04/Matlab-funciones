function y = isieee(x)
%ISIEEE	True for computers with IEEE arithmetic.
%	ISIEEE returns 1 on machines with IEEE arithmetic
%	and 0 on machines without IEEE arithmetic.
% 	Machines with IEEE:  IBM PC, most UNIX workstations, Macintosh.
% 	Machines without: VAX, Cray.
%
%	See also COMPUTER.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

comp = [computer '   '];
y = ~(strcmp(comp(1:3),'VAX') | strcmp(comp(1:4),'CRAY'));
