function [arrtype, varargout] = typesize(inputval)
% typesize returns a character 's' for scalar, 'v'
% for vector, or 'm' for matrix input argument
% also returns length of a vector or dimensions of matrix
% Format: typesize(inputArgument)
 
[r c ] = size(inputval);
 
if r==1 && c==1
    arrtype = 's';
elseif r==1 || c==1
    arrtype = 'v';
    varargout{1} = length(inputval);
else
    arrtype = 'm';
    varargout{1} = r;
    varargout{2} = c;
end
end
