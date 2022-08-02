function ptstr = strpoint(ptstruct)
% strpoint receives a struct containing x and y
% coordinates and returns a string '(x,y)'
% Format: strpoint(structure with x and y fields)

ptstr = sprintf('(%d, %d)', ptstruct.x, ptstruct.y);
end