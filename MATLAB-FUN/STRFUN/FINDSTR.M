function k = findstr(s1,s2)
%FINDSTR Find one string within another.
%	K = FINDSTR(S1,S2) returns the starting indices of any occurrences
%	of the shorter of the two strings in the longer.
%	Example:
%	    s = 'How much wood would a woodchuck chuck?';
%	    findstr(s,'a')    returns  21
%	    findstr(s,'wood') returns  [10 23]
%	    findstr(s,'Wood') returns  []
%	    findstr(s,' ')    returns  [4 9 14 20 22 32]
%	See also STRCMP.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Make s2 the shorter.
if length(s1) < length(s2)
   t = s1; s1 = s2; s2 = t;
end

% Quick exit for empty string. 
if isempty(s2)
   k = [];
   return
end

% Extend s1 by something as long as s2, but which doesn't match.
s1 = [s1 0*s2];

% Repeatedly shorten an index vector which points to increasingly 
% longer matches. 
k = 1:length(s1);
for i = 1:length(s2)
   k = k(find(s1(k+i-1) == s2(i)));
end
