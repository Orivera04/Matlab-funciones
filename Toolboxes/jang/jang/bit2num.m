function num = bit2num(bit, range)
% BIT2NUM Conversion from bit string representations to decimal numbers.
%	BIT2NUM(BIT, RANGE) converts a bit string representation BIT ( a 0-1
%	vector) to a decimal number, where RANGE is a two-element vector
%	specifying the range of the converted decimal number.
%
%	For example:
%
%	bit2num([1 1 0 1], [0, 15])
%	bit2num([0 1 1 0 0 0 1], [0, 127])

%	Roger Jang, 12-24-94

integer = polyval(bit, 2);
num = integer*((range(2)-range(1))/(2^length(bit)-1)) + range(1);
