function outcost = cylcost(radius, height, cost)
% cylcost calculates the cost of constructing a closed
%   cylinder
% Format of call: cylcost(radius, height, cost)
% Returns the total cost 
 
% The radius and height are in inches
% The cost is per square foot
 
% Calculate surface area in square inches
surf_area = 2 * pi * radius * height + 2 * pi * radius ^ 2;
 
% Convert surface area in square feet and round up
surf_areasf = ceil(surf_area/144);
 
% Calculate cost
outcost = surf_areasf * cost;
end
