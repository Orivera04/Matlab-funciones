function s1 = deblank(s)
%DEBLANK Strip trailing blanks from end of a string.
%	DEBLANK(S) removes the trailing blanks and any null characters from
%	the string S.  A null character is one that has an absolute value of 0.

%	L. Shure, 6-17-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if ~isstr(s)
	error('Input must be a string.')
end

if isempty(s)
	s1 = s;
	return;
end

% first remove trailing blanks
b = ' ';
ns = length(s);
nbc = min(find(fliplr(s) ~= b));
if isempty(nbc)
	s1 = '';
	return
end
s1 = s(1:(length(s)-nbc(1)+1));

% remove any null characters (null character ==> abs(s) == 0)
s1(find(abs(s)==0)) = [];
