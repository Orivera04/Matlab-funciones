function [row col varargout] = mysize(mat)
% mysize returns dimensions of input argument
% and possibly also total # of elements
% Format: mysize(inputArgument)
 
[row col] = size(mat);
 
if nargout == 3
    varargout{1} = row*col;
end
end
