a = 2;
x = a/2;

for i = 1:6
	x = (x + a / x) / 2;
	disp( x )
end

disp( 'Matlab''s value: ' )
disp( sqrt(2) )