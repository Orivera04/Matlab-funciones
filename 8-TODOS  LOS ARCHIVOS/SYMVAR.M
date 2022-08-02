function v = symvar(s,arg2)
%SYMVAR	Determine the symbolic variables in an expression.
%	SYMVAR(S) searches the string S for an isolated lower case alphabetic
%	character, other than 'i' or 'j', that is not part of a word formed
%	from several alphabetic characters.   If such a character exists and is
%	unique, it is returned.  If no such character exists, 'x' is returned.
%	If the character is not unique, the one closest to 'x' is returned.
%	If there is a tie, the one later in the alphabet is chosen.
%
%	SYMVAR(S,'t') chooses the variable closest to 't' instead of 'x'.
%
%	SYMVAR(S,N), for scalar integer N, searches S for N different
%	isolated lower case alphabetic characters, excluding 'i' and 'j'.
%	If exactly N such characters exist, a list of them is returned.
%	If not, an error results.
%
%	SYMVAR(S,N), for an integer vector N with at least two components,
%	searches the string S for several different isolated characters.
%	When N is a vector, SYMVAR(S,N) will never report an error.
%	If the number found is between min(N) and max(N), a list is returned.
%	If the number found is less than min(N), an empty matrix is returned.
%	If the number found is greater than max(N), NaN is returned.
%
%	Examples:
%	    symvar('sin(x)') is 'x'.
%	    symvar('sin(pi*t)') is 't'.
%	    symvar('a+y') is 'y'
%	    symvar('3*i+4*j') is 'x'
%	    symvar('pi',[1 1]) is empty.
%	    f = '3*x+4*y';
%	    symvar(f) is 'x'
%	    symvar(f,2) is 'x,y'
%	    g = 'Dx = y; Dy = -x + sin(t)';
%	    symvar(g,2:3) is 't,x,y'.
%	    symvar(g,[1 1]) is NaN.
%	    symvar(g,n) for scalar n ~= 3 is an error

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.12 $  $Date: 1994/06/16 14:58:07 $

if nargin < 2
   x = 'x';
   n = 1;
elseif isstr(arg2)
   x = arg2;
   n = 1;
else
   n = arg2;
   x = 'x';
end

% Make one long string.
[m,w] = size(s);
s = s';
s = [' ' s(:)' ' '];

% Find all letters, except 'i' or 'j'.
k = find((('a'<=s) & (s<='h')) | (('k'<=s) & (s<='z')));

% Eliminate 'e' used in numeric exponent.
k = k(find(s(k) ~= 'e' | ((s(k-1) < '0' | s(k-1) > '9') & s(k-1) ~= '.')));

% Find letters not preceeded or followed by other letters.
k = k(find(~isletter(s(k-1)) & ~isletter(s(k+1))));

% Sort list alphabetically and delete duplicates.
s = sort(s(k));
v = [];
if ~isempty(s), v = s(1); end
k = length(v);
for j = 1:length(s)
   if s(j) ~= v(2*k-1)
      v = [v ',' s(j)];
      k = k+1;
   end
end

% Check for acceptable number.
if k >= min(n) & k <= max(n)
   break
elseif length(n) > 1
   if k < min(n)
      v = [];
   else
      v = NaN;
   end
elseif n == 1
   if k == 0
      v = x;
   else
      % Find letter closest to x.
      t = abs(v - x);
      v = v(max(find(t == min(t))));
   end
else
   error('Symbolic variable(s) not uniquely determined.')
end
