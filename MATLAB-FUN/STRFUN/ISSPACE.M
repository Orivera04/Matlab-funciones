function t = isspace(c)
%ISSPACE True if space, newline, carriage return, tab, vert. tab, or formfeed.
%       For a string S, ISSPACE(S) is 1 for white space characters and
%       0 otherwise.
 
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Control Characters
%	HT = 9;		% Horizontal Tab
%	NL = 10;	% New Line
%	VT = 11;	% Vertical Tab
%	FF = 12;	% Form Feed
%	CR = 13;	% Carriage Return

t = ((c == ' ') | ((9 <= c) & (c <= 13)));
