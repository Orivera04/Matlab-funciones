function bit = num2bit(x, range)

bit_n = 8;
dx = (range(2)-range(1))/(2^bit_n-1);
integer = round((x-range(1))/dx);

bit = zeros(1, bit_n);
for i = bit_n:-1:1, 
	bit(i) = rem(integer, 2);
	integer = floor(integer/2);
end
	
