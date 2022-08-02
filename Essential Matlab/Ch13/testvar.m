function [varargout] = testvar(varargin)

for i = 1:length(varargin)
    x(i) = varargin{i};   % display contents of ith cell in cell array
end

for i = 1:nargout
    varargout{i} = 2*x(i);
end

