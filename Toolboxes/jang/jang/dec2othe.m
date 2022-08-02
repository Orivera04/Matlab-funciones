function out = dec2othe(number, base, digit_n)
% DEC2OTHE Conversion of decimal to other number representation.
%	DEC2OTHE(D) convert decimal integer D into binary representation.
%
%	DEC2OTHE(D, BASE) convert decimal integer D into other representation
%	with base BASE.
%
%	DEC2OTHE(D, BASE, N) pads with leading zeros so the return vector has
%	N elements. If the converted representation has a length larger than
%	N, then N is ignored and the complete representation is returned.
%
%	Roger Jang, Aug-10-1995

if (number ~= round(number)) | (number < 0)
	error('requires positive integer arguments.');
end

if nargin < 3, digit_n = 0; end
if nargin < 2, base = 2; end

if number == 0,
	out = 0;
else
	out = [];
	while number > 0
		tmp = rem(number, base);
		number = fix(number/base);
		out = [tmp out];
	end 
end

if length(out) < digit_n,
	out = [zeros(1, digit_n-length(out)) out];
end
