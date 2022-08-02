	% This script calculates the area of a circle
	% It prompts the user for the radius
	radius = input('Please enter the radius: ');
	% It then calls our function to calculate the
	%  area and then prints the result
	area = calcarea(radius);
	fprintf('For a circle with a radius of %.2f,',radius)
	fprintf(' the area is %.2f\n',area)
