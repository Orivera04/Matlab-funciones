function [aa,bb,cc,dd] = append(a1,b1,c1,d1,a2,b2,c2,d2)
%APPEND Append together the dynamics of two state-space systems.
%	[A,B,C,D] = APPEND(A1,B1,C1,D1,A2,B2,C2,D2)  produces an aggregate
%	state-space system consisting of the appended dynamics of systems
%	1 and 2.  The resulting system is:
%	         .
%	        |x1| = |A1 0| |x1| + |B1 0| |u1|
%	        |x2|   |0 A2| |x2| + |0 B2| |u2|
%
%	        |y1| = |C1 0| |x1| + |D1 0| |u1|
%	        |y2|   |0 C2| |x2| + |0 D2| |u2|
%
%	See also: SERIES, FEEDBACK, CLOOP.

% 	Copyright (c) 1986-93 by the MathWorks, Inc.

error(nargchk(8,8,nargin));
error(abcdchk(a1,b1,c1,d1));
error(abcdchk(a2,b2,c2,d2));

[ma1,na1] = size(a1);
[md1,nd1] = size(d1);
[ma2,na2] = size(a2);
[md2,nd2] = size(d2);
aa = [a1 zeros(ma1,na2);zeros(ma2,na1) a2];
bb = [b1 zeros(ma1,nd2);zeros(ma2,nd1) b2];
cc = [c1 zeros(md1,na2);zeros(md2,na1) c2];
dd = [d1 zeros(md1,nd2);zeros(md2,nd1) d2];
