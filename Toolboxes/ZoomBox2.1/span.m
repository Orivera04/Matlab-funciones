function output = span(input);
%SPAN finds the range of a vector.
%   output = max(input(:)) - min(input(:));
%
%   Helper function for ZOOMBOX.

output = max(input(:)) - min(input(:));