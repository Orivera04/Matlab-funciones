	function [area, circum] = areacirc(rad)
	% areacirc returns the area and 
	% the circumference of a circle
    % Format: areacirc(radius)
    
	area = pi * rad .* rad;
	circum = 2 * pi * rad;
    end
